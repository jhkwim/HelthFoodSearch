# 건강기능식품 검색 (Health Food Search)

[![Release Build](https://github.com/jhkwim/HelthFoodSearch/actions/workflows/build_all.yml/badge.svg?branch=release)](https://github.com/jhkwim/HelthFoodSearch/actions/workflows/build_all.yml)

식약처 공공데이터를 활용하여 **건강기능식품 정보를 쉽고 빠르게 검색**할 수 있는 크로스 플랫폼 애플리케이션입니다.
제품명뿐만 아니라 포함된 원료를 기준으로도 검색이 가능하여, 사용자가 원하는 성분의 제품을 효율적으로 찾을 수 있습니다.

## 🚀 주요 기능 (Key Features)

### 🔍 빠르고 강력한 검색
- **제품명 검색**: 제품명에 포함된 키워드로 실시간 검색을 지원합니다.
- **필터링**: 품목제조신고번호, 제조사 등으로 결과를 좁혀볼 수 있습니다.

### 💊 스마트한 성분 검색
- **원료별 검색**: 원하는 기능성 원료가 포함된 제품을 찾습니다.
- **검색 모드 지원**:
    - **포함 검색 (Include)**: 선택한 원료를 모두 포함하는 제품 검색 (복합 기능성 제품 찾기에 유용)
    - **전용 검색 (Exclusive)**: 오직 선택한 원료만으로 구성된 제품 검색 (단일 성분 제품 찾기에 유용)

### 📄 상세한 제품 정보
- **상세 화면**: 식약처에 등록된 정확한 정보를 제공합니다.
    - 섭취량 및 섭취방법
    - 기능성 내용 및 기준 규격
    - 섭취 시 주의사항 및 보관 방법
    - 원재료명 (주원료 및 부원료 구분)

### ⚙️ 사용자 편의 기능
- **큰 글씨 모드**: 시력이 좋지 않은 사용자를 위해 앱 전체 글자 크기를 1.3배 확대할 수 있습니다.
- **오프라인 데이터**: 최초 실행 시 데이터를 기기에 저장(Hive)하여 네트워크 없이도 빠른 검색이 가능합니다.
- **데이터 관리**: 언제든지 최신 데이터로 업데이트하거나 저장된 데이터를 초기화할 수 있습니다.

---

## 🛠 기술 스택 (Tech Stack)

이 프로젝트는 **Flutter**를 사용하여 개발되었으며, **Clean Architecture** 원칙을 따릅니다.

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Cubit)
- **Local Database**: [Hive](https://pub.dev/packages/hive) (Fast NoSQL DB)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it) & [injectable](https://pub.dev/packages/injectable)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Routing**: [go_router](https://pub.dev/packages/go_router)

---

## 🏁 시작하기 (Getting Started)

이 프로젝트를 로컬에서 실행하려면 Flutter SDK가 설치되어 있어야 합니다.

### 1. API 키 설정 (선택 사항)
앱 내에서 API 키를 입력할 수 있지만, 개발 편의를 위해 설정 파일에 미리 지정할 수도 있습니다.
(공공데이터포털 '건강기능식품 품목제조신고(원료성분) 현황' API 키 필요)

### 2. 설치 및 실행

```bash
# 레포지토리 클론
git clone https://github.com/jhkwim/HelthFoodSearch.git
cd HelthFoodSearch

# 의존성 패키지 설치
flutter pub get

# 코드 생성 (JSON Serialization, Hive Adapters 등)
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행 (macOS)
flutter run -d macos
```

## 📝 라이선스
This project is open source and available under the [MIT License](LICENSE).
