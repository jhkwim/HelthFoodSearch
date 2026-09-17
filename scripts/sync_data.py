#!/usr/bin/env python3
"""
scripts/sync_data.py
식품안전나라 건강기능식품(I0030) 공공데이터 수집 및 Gzip 압축 스크립트
"""

import argparse
import gzip
import json
import os
import sys
import time
from datetime import datetime, timezone, timedelta

import requests
from requests.adapters import HTTPAdapter
from urllib3.util import Retry

KST = timezone(timedelta(hours=9))


def create_resilient_session():
    """지수 백오프 및 자동 재시도가 적용된 HTTP 세션 생성"""
    session = requests.Session()
    retries = Retry(
        total=5,
        backoff_factor=1.5,
        status_forcelist=[429, 500, 502, 503, 504],
        raise_on_status=False,
    )
    adapter = HTTPAdapter(max_retries=retries)
    session.mount("https://", adapter)
    session.mount("http://", adapter)
    return session


def fetch_food_data(api_key: str, is_sample: bool = False):
    """식품안전나라 I0030 데이터를 페이징 수집하여 정제된 리스트 반환"""
    session = create_resilient_session()
    base_url = f"https://openapi.foodsafetykorea.go.kr/api/{api_key}/I0030/json"

    # 1. 초기 1건 호출하여 total_count 및 에러 여부 확인
    print("[1/3] 식품안전나라 API 상태 및 전체 건수 조회 중...")
    init_res = session.get(f"{base_url}/1/1", timeout=30)
    init_res.raise_for_status()
    init_json = init_res.json()

    i0030_data = init_json.get("I0030")
    if not i0030_data:
        res_info = init_json.get("RESULT", {})
        code = res_info.get("CODE", "UNKNOWN")
        msg = res_info.get("MSG", "응답 데이터 없음")
        raise RuntimeError(f"API 초기 응답 오류: [{code}] {msg}")

    result_code = i0030_data.get("RESULT", {}).get("CODE")
    result_msg = i0030_data.get("RESULT", {}).get("MSG", "")
    if result_code != "INFO-000":
        raise RuntimeError(f"식품안전나라 API 서비스 제한/오류: [{result_code}] {result_msg}")

    total_count = int(i0030_data.get("total_count", 0))
    print(f"-> 전체 등록 품목 수: {total_count:,}건")

    if is_sample:
        target_count = min(10, total_count)
        print(f"-> 샘플 모드 활성화: 상위 {target_count}건만 수집합니다.")
    else:
        target_count = total_count

    items = []
    step = 1000
    start = 1

    print(f"[2/3] 페이징 수집 시작 (배치 크기: {step})...")
    while start <= target_count:
        end = min(start + step - 1, target_count)
        page_url = f"{base_url}/{start}/{end}"
        res = session.get(page_url, timeout=40)
        res.raise_for_status()
        page_json = res.json()

        page_rows = page_json.get("I0030", {}).get("row", [])
        if not page_rows:
            print(f"경고: {start}~{end} 구간에 row 데이터가 비어 있습니다.")
            break

        for row in page_rows:
            # 원본 API 키명을 그대로 보존하여 DTO 호환성 100% 유지
            items.append({
                "PRDLST_REPORT_NO": (row.get("PRDLST_REPORT_NO") or "").strip(),
                "PRDLST_NM": (row.get("PRDLST_NM") or "").strip(),
                "RAWMTRL_NM": (row.get("RAWMTRL_NM") or "").strip(),
                "BSSH_NM": (row.get("BSSH_NM") or "").strip(),
                "PRMS_DT": (row.get("PRMS_DT") or "").strip(),
                "PRIMARY_FNCLTY": (row.get("PRIMARY_FNCLTY") or "").strip(),
                "IFTKN_ATNT_MATR_CN": (row.get("IFTKN_ATNT_MATR_CN") or "").strip(),
                "NTK_MTHD": (row.get("NTK_MTHD") or "").strip(),
                "CSTDY_MTHD": (row.get("CSTDY_MTHD") or "").strip(),
                "POG_DAYCNT": (row.get("POG_DAYCNT") or "").strip(),
                "DISPOS": (row.get("DISPOS") or "").strip(),
                "LCNS_NO": (row.get("LCNS_NO") or "").strip(),
                "PRDLST_CDNM": (row.get("PRDLST_CDNM") or "").strip(),
                "STDR_STND": (row.get("STDR_STND") or "").strip(),
                "HIENG_LNTRT_DVS_NM": (row.get("HIENG_LNTRT_DVS_NM") or "").strip(),
                "PRODUCTION": (row.get("PRODUCTION") or "").strip(),
                "CHILD_CRTFC_YN": (row.get("CHILD_CRTFC_YN") or "").strip(),
                "PRDT_SHAP_CD_NM": (row.get("PRDT_SHAP_CD_NM") or "").strip(),
                "FRMLC_MTRQLT": (row.get("FRMLC_MTRQLT") or "").strip(),
                "INDUTY_CD_NM": (row.get("INDUTY_CD_NM") or "").strip(),
                "LAST_UPDT_DTM": (row.get("LAST_UPDT_DTM") or "").strip(),
                "INDIV_RAWMTRL_NM": (row.get("INDIV_RAWMTRL_NM") or "").strip(),
                "ETC_RAWMTRL_NM": (row.get("ETC_RAWMTRL_NM") or "").strip(),
                "CAP_RAWMTRL_NM": (row.get("CAP_RAWMTRL_NM") or "").strip(),
                "FRMLC_MTHD": (row.get("FRMLC_MTHD") or "").strip(),
            })

        print(f"  진행률: {len(items):,}/{target_count:,} ({len(items)/target_count*100:.1f}%)")
        start += step
        time.sleep(0.3)  # 공공 API Rate Limiting 완화

    return items, total_count


def save_atomic_files(output_dir: str, items: list, full_total_count: int, is_sample: bool):
    """원자적(Atomic) 파일 저장 및 Gzip 압축"""
    os.makedirs(output_dir, exist_ok=True)
    now_kst = datetime.now(KST)
    version_str = now_kst.strftime("%Y%m%d_%H%M")

    # 1. Gzip 압축 파일 생성 (.tmp -> foods_latest.json.gz)
    target_gz = os.path.join(output_dir, "foods_latest.json.gz")
    tmp_gz = target_gz + ".tmp"

    print(f"[3/3] Gzip 압축 및 메타데이터 생성 중: {target_gz}")
    with gzip.open(tmp_gz, "wt", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False)

    os.replace(tmp_gz, target_gz)
    gz_size = os.path.getsize(target_gz)

    # 2. version.json 메타데이터 파일 생성 (.tmp -> version.json)
    target_ver = os.path.join(output_dir, "version.json")
    tmp_ver = target_ver + ".tmp"

    version_data = {
        "version": version_str,
        "total_count": len(items) if is_sample else full_total_count,
        "file_size": gz_size,
        "updated_at": now_kst.isoformat(),
        "data_url": "foods_latest.json.gz",
    }

    with open(tmp_ver, "w", encoding="utf-8") as f:
        json.dump(version_data, f, ensure_ascii=False, indent=2)

    os.replace(tmp_ver, target_ver)

    print("=" * 60)
    print(f"동기화 완료: 총 {len(items):,}건")
    print(f"압축 파일 크기: {gz_size / (1024 * 1024):.2f} MB")
    print(f"버전: {version_str}")
    print("=" * 60)


def main():
    parser = argparse.ArgumentParser(description="식품안전나라 I0030 데이터 야간 수집 스크립트")
    parser.add_argument("--api-key", default=os.environ.get("FOOD_SAFETY_API_KEY"), help="식품안전나라 인증키")
    parser.add_argument("--output-dir", default="./dist_data", help="결과 파일 저장 디렉토리")
    parser.add_argument("--sample", action="store_true", help="테스트용 샘플(10건)만 수집")
    args = parser.parse_args()

    if not args.api_key:
        print("에러: FOOD_SAFETY_API_KEY 환경변수 또는 --api-key 인자가 필요합니다.", file=sys.stderr)
        sys.exit(1)

    try:
        items, full_count = fetch_food_data(args.api_key, is_sample=args.sample)

        # 무결성 검증 (일반 모드일 때 최소 30,000건 이상이어야 함)
        if not args.sample and len(items) < 30000:
            raise ValueError(f"수집된 데이터 건수({len(items):,}건)가 기준치(30,000건)에 미달하여 배포를 중단합니다.")

        save_atomic_files(args.output_dir, items, full_count, is_sample=args.sample)
    except Exception as e:
        print(f"❌ 데이터 동기화 실패: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
