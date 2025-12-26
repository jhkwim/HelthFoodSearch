// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '건강기능식품 검색';

  @override
  String get navProductSearch => '제품명 검색';

  @override
  String get navIngredientSearch => '원료별 검색';

  @override
  String get searchHintProduct => '제품명을 입력하세요';

  @override
  String get searchHintIngredient => '원료명을 입력하세요';

  @override
  String get searchEmptyGuide => '왼쪽 목록에서 제품을 선택하세요';

  @override
  String searchResultCount(Object count) {
    return '$count건이 검색되었습니다';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsDisplaySection => '화면 설정';

  @override
  String get settingsLargeText => '큰 글씨 모드';

  @override
  String get settingsLargeTextDesc => '앱 전체 글씨를 크게 봅니다.';

  @override
  String get settingsApiSection => 'API 설정';

  @override
  String get settingsApiKey => 'API 키';

  @override
  String get settingsDataSection => '데이터 관리';

  @override
  String get settingsDataRefresh => '데이터 다시 받기';

  @override
  String get settingsDataRefreshDesc => '서버에서 최신 데이터를 받아옵니다.';

  @override
  String settingsDataSaved(String count) {
    return '저장된 데이터: $count 건';
  }

  @override
  String settingsDataSavedWithSize(String count, String size) {
    return '저장된 데이터: $count 건 ($size MB)';
  }

  @override
  String get settingsDataDelete => '데이터 삭제';

  @override
  String get settingsDataDeleteDesc => '저장된 모든 데이터를 삭제합니다.';

  @override
  String get settingsDataDeleteConfirmTitle => '데이터 삭제';

  @override
  String get settingsDataDeleteConfirmContent => '정말 삭제하시겠습니까?';

  @override
  String get settingsDataDeleteCancel => '취소';

  @override
  String get settingsDataDeleteConfirm => '삭제';

  @override
  String get settingsDataRefreshNotice => '데이터 다시 받기를 수행하면 데이터가 갱신됩니다.';

  @override
  String get settingsAppInfoSection => '앱 정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsLoading => '로딩 중...';

  @override
  String get settingsNotSet => '설정되지 않음';

  @override
  String syncProgress(String percent) {
    return '데이터 다운로드 중... ($percent%) - 검색 가능';
  }

  @override
  String get searchProductHintExample => '예: 비타민';

  @override
  String get searchProductEmpty => '검색 결과가 없습니다.';

  @override
  String get searchProductInitial => '제품명을 입력하여 검색하세요.';

  @override
  String get searchIngredientLabel => '원료 추가';

  @override
  String get searchIngredientHintExample => '원료명 입력 (예: 홍삼)';

  @override
  String get searchModeLabel => '검색 모드:';

  @override
  String get searchModeInclude => '포함 검색 (+α)';

  @override
  String get searchModeExclusive => '전용 검색 (Only)';

  @override
  String get searchIngredientEmptyResult => '조건에 맞는 제품이 없습니다.';

  @override
  String get searchIngredientInitial => '원료를 추가하면 자동으로 검색됩니다.';

  @override
  String errorOccurred(String message) {
    return '오류 발생: $message';
  }

  @override
  String metaReportNo(String reportNo) {
    return '신고번호: $reportNo';
  }

  @override
  String get metaMainIngredients => '주원료: ';

  @override
  String get detailTitle => '제품 상세 정보';

  @override
  String get detailTabFuncRaw => '기능성 원료';

  @override
  String get detailTabEtcRaw => '기타 원자재';

  @override
  String get detailTabCapRaw => '복합/캡슐';

  @override
  String get detailSectionBasic => '기본 정보';

  @override
  String get detailLabelCompany => '업소명';

  @override
  String get detailLabelReportNo => '신고번호';

  @override
  String get detailLabelRegDate => '등록일자';

  @override
  String get detailLabelExpireDate => '소비기한';

  @override
  String get detailLabelAppearance => '성상';

  @override
  String get detailLabelForm => '제품형태';

  @override
  String get detailSectionPacking => '포장 정보';

  @override
  String get detailLabelPackMaterial => '포장재질';

  @override
  String get detailLabelPackMethod => '포장방법';

  @override
  String get detailSectionIntake => '섭취량 및 섭취방법';

  @override
  String get detailSectionFunc => '기능성 내용';

  @override
  String get detailSectionStandard => '기준 및 규격';

  @override
  String get detailSectionCaution => '주의사항 및 보관';

  @override
  String get detailLabelCautionIntake => '섭취 시 주의사항';

  @override
  String get detailLabelCautionStorage => '보존 및 유통기준';

  @override
  String get detailSectionIngredients => '원료 정보';

  @override
  String get detailLabelRawMaterialsSearchable => '원재료 정보 (검색 가능)';

  @override
  String detailSelectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get detailSectionRawMaterialsReport => '품목제조신고 원재료';

  @override
  String detailFabSearchWithIngredients(int count) {
    return '$count개 원료로 검색';
  }

  @override
  String get settingsRefiningTitle => '원재료 정제 중';

  @override
  String get settingsRefiningComplete => '원재료 재정제가 완료되었습니다.';

  @override
  String get settingsThemeTitle => '앱 테마';

  @override
  String get settingsThemeSystem => '시스템 설정';

  @override
  String get settingsThemeLight => '라이트 모드';

  @override
  String get settingsThemeDark => '다크 모드';

  @override
  String get settingsThemeSelectTitle => '테마 선택';

  @override
  String get settingsUpdateParamsTitle => '업데이트 안내 주기';

  @override
  String get settingsUpdateParamsDesc => '데이터 업데이트 필요 여부를 체크하는 주기입니다.';

  @override
  String updateIntervalDays(int days) {
    return '$days일';
  }

  @override
  String get settingsDevToolsTitle => '개발자 도구 (테스트용)';

  @override
  String get settingsDevForceExpire => '강제 업데이트 만료 처리';

  @override
  String get settingsDevForceExpireDesc =>
      '마지막 업데이트 시간을 30일 전으로 되돌립니다.\n앱 재시작 시 업데이트 팝업을 테스트할 수 있습니다.';

  @override
  String get settingsDevForceExpireSuccess => '업데이트 시간이 만료되었습니다. 앱을 재시작하세요.';

  @override
  String get settingsExportTitle => '데이터 엑셀 내보내기';

  @override
  String get settingsExportDesc => '저장된 식품 정보를 엑셀 파일로 저장하거나 공유합니다.';

  @override
  String get settingsExporting => '엑셀 파일 생성 중...';

  @override
  String settingsErrorExport(String error) {
    return '데이터 내보내기 실패: $error';
  }

  @override
  String settingsErrorRefine(String error) {
    return '데이터 재정제 실패: $error';
  }

  @override
  String get ruleUpdatesAndRefinement => '정제 규칙 업데이트 및 재정제';

  @override
  String ruleUpdatesDescWithTime(String time) {
    return '최신 규칙으로 원재료명을 다시 정리합니다.\n최종 업데이트: $time';
  }

  @override
  String get ruleUpdatesDesc => '최신 규칙으로 원재료명을 다시 정리합니다.';

  @override
  String apiLastUpdate(String time) {
    return '최종 업데이트: $time';
  }

  @override
  String get apiParamsTitle => 'API 설정';

  @override
  String get apiGuide1 => '식품안전나라 API 키를 입력해주세요.';

  @override
  String get apiGuide2 => '공공데이터포털에서 발급받은 키가 필요합니다.';

  @override
  String get apiInputLabel => 'API 인증키';

  @override
  String get apiInputHint => '인증키를 입력하세요';

  @override
  String get apiInputError => '키를 입력해주세요';

  @override
  String get apiSaveButton => '저장하고 시작하기';

  @override
  String get favoritesTitle => '즐겨찾기';

  @override
  String get favoritesEmpty => '즐겨찾기가 없습니다';

  @override
  String get favoritesEmptyGuide => '상세 화면에서 하트 아이콘을 눌러\n즐겨찾기에 추가하세요';

  @override
  String get favoritesErrorTitle => '오류가 발생했습니다';

  @override
  String favoritesViewDetail(String name) {
    return '$name 상세 보기';
  }

  @override
  String get updateNeededTitle => '데이터 업데이트 필요';

  @override
  String get updateNeededContent =>
      '마지막 업데이트로부터 30일이 지났습니다.\n최신 데이터로 업데이트하시겠습니까?';

  @override
  String get updateLater => '나중에';

  @override
  String get updateNow => '업데이트';

  @override
  String get downloadTitle => '데이터 다운로드';

  @override
  String downloadCompletePercent(int percent) {
    return '$percent% 완료';
  }

  @override
  String get downloadRunInBackground => '백그라운드에서 계속하기';

  @override
  String get downloadStart => '다운로드 시작';

  @override
  String get downloadingTitle => '최신 데이터를 받아옵니다.';

  @override
  String get downloadingDesc => '데이터가 많아 시간이 소요될 수 있습니다.\n와이파이 환경을 권장합니다.';

  @override
  String get favoriteProductNotFound => '제품 정보를 찾을 수 없습니다';

  @override
  String get errorInvalidArgs => '잘못된 접근입니다';
}
