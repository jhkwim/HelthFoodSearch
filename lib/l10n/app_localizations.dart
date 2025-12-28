import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'건강기능식품 검색'**
  String get appTitle;

  /// No description provided for @navProductSearch.
  ///
  /// In ko, this message translates to:
  /// **'제품명 검색'**
  String get navProductSearch;

  /// No description provided for @navIngredientSearch.
  ///
  /// In ko, this message translates to:
  /// **'원료별 검색'**
  String get navIngredientSearch;

  /// No description provided for @searchHintProduct.
  ///
  /// In ko, this message translates to:
  /// **'제품명을 입력하세요'**
  String get searchHintProduct;

  /// No description provided for @searchHintIngredient.
  ///
  /// In ko, this message translates to:
  /// **'원료명을 입력하세요'**
  String get searchHintIngredient;

  /// No description provided for @searchEmptyGuide.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 목록에서 제품을 선택하세요'**
  String get searchEmptyGuide;

  /// No description provided for @searchResultCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}건이 검색되었습니다'**
  String searchResultCount(Object count);

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @settingsDisplaySection.
  ///
  /// In ko, this message translates to:
  /// **'화면 설정'**
  String get settingsDisplaySection;

  /// No description provided for @settingsLargeText.
  ///
  /// In ko, this message translates to:
  /// **'큰 글씨 모드'**
  String get settingsLargeText;

  /// No description provided for @settingsLargeTextDesc.
  ///
  /// In ko, this message translates to:
  /// **'앱 전체 글씨를 크게 봅니다.'**
  String get settingsLargeTextDesc;

  /// No description provided for @settingsApiSection.
  ///
  /// In ko, this message translates to:
  /// **'API 설정'**
  String get settingsApiSection;

  /// No description provided for @settingsApiKey.
  ///
  /// In ko, this message translates to:
  /// **'API 키'**
  String get settingsApiKey;

  /// No description provided for @settingsDataSection.
  ///
  /// In ko, this message translates to:
  /// **'데이터 관리'**
  String get settingsDataSection;

  /// No description provided for @settingsDataRefresh.
  ///
  /// In ko, this message translates to:
  /// **'데이터 다시 받기'**
  String get settingsDataRefresh;

  /// No description provided for @settingsDataRefreshDesc.
  ///
  /// In ko, this message translates to:
  /// **'서버에서 최신 데이터를 받아옵니다.'**
  String get settingsDataRefreshDesc;

  /// No description provided for @settingsDataSaved.
  ///
  /// In ko, this message translates to:
  /// **'저장된 데이터: {count} 건'**
  String settingsDataSaved(String count);

  /// No description provided for @settingsDataSavedWithSize.
  ///
  /// In ko, this message translates to:
  /// **'저장된 데이터: {count} 건 ({size} MB)'**
  String settingsDataSavedWithSize(String count, String size);

  /// No description provided for @settingsDataDelete.
  ///
  /// In ko, this message translates to:
  /// **'데이터 삭제'**
  String get settingsDataDelete;

  /// No description provided for @settingsDataDeleteDesc.
  ///
  /// In ko, this message translates to:
  /// **'저장된 모든 데이터를 삭제합니다.'**
  String get settingsDataDeleteDesc;

  /// No description provided for @settingsDataDeleteConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'데이터 삭제'**
  String get settingsDataDeleteConfirmTitle;

  /// No description provided for @settingsDataDeleteConfirmContent.
  ///
  /// In ko, this message translates to:
  /// **'정말 삭제하시겠습니까?'**
  String get settingsDataDeleteConfirmContent;

  /// No description provided for @settingsDataDeleteCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get settingsDataDeleteCancel;

  /// No description provided for @settingsDataDeleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get settingsDataDeleteConfirm;

  /// No description provided for @settingsDataRefreshNotice.
  ///
  /// In ko, this message translates to:
  /// **'데이터 다시 받기를 수행하면 데이터가 갱신됩니다.'**
  String get settingsDataRefreshNotice;

  /// No description provided for @settingsAppInfoSection.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get settingsAppInfoSection;

  /// No description provided for @settingsVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get settingsVersion;

  /// No description provided for @settingsLoading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get settingsLoading;

  /// No description provided for @settingsNotSet.
  ///
  /// In ko, this message translates to:
  /// **'설정되지 않음'**
  String get settingsNotSet;

  /// No description provided for @syncProgress.
  ///
  /// In ko, this message translates to:
  /// **'데이터 다운로드 중... ({percent}%) - 검색 가능'**
  String syncProgress(String percent);

  /// No description provided for @searchProductHintExample.
  ///
  /// In ko, this message translates to:
  /// **'예: 비타민'**
  String get searchProductHintExample;

  /// No description provided for @searchProductEmpty.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다.'**
  String get searchProductEmpty;

  /// No description provided for @searchProductInitial.
  ///
  /// In ko, this message translates to:
  /// **'제품명을 입력하여 검색하세요.'**
  String get searchProductInitial;

  /// No description provided for @searchIngredientLabel.
  ///
  /// In ko, this message translates to:
  /// **'원료 추가'**
  String get searchIngredientLabel;

  /// No description provided for @searchIngredientHintExample.
  ///
  /// In ko, this message translates to:
  /// **'원료명 입력 (예: 홍삼)'**
  String get searchIngredientHintExample;

  /// No description provided for @searchModeLabel.
  ///
  /// In ko, this message translates to:
  /// **'검색 모드:'**
  String get searchModeLabel;

  /// No description provided for @searchModeInclude.
  ///
  /// In ko, this message translates to:
  /// **'포함 검색 (+α)'**
  String get searchModeInclude;

  /// No description provided for @searchModeExclusive.
  ///
  /// In ko, this message translates to:
  /// **'전용 검색 (Only)'**
  String get searchModeExclusive;

  /// No description provided for @searchIngredientEmptyResult.
  ///
  /// In ko, this message translates to:
  /// **'조건에 맞는 제품이 없습니다.'**
  String get searchIngredientEmptyResult;

  /// No description provided for @searchIngredientInitial.
  ///
  /// In ko, this message translates to:
  /// **'원료를 추가하면 자동으로 검색됩니다.'**
  String get searchIngredientInitial;

  /// No description provided for @errorNetwork.
  ///
  /// In ko, this message translates to:
  /// **'인터넷 연결을 확인해주세요.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In ko, this message translates to:
  /// **'서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.'**
  String get errorServer;

  /// No description provided for @errorCache.
  ///
  /// In ko, this message translates to:
  /// **'데이터 저장에 실패했습니다.'**
  String get errorCache;

  /// No description provided for @errorUnknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 오류가 발생했습니다.'**
  String get errorUnknown;

  /// No description provided for @errorApiKeyMissing.
  ///
  /// In ko, this message translates to:
  /// **'API 키가 설정되지 않았습니다.'**
  String get errorApiKeyMissing;

  /// No description provided for @errorDataParsing.
  ///
  /// In ko, this message translates to:
  /// **'데이터 처리에 실패했습니다.'**
  String get errorDataParsing;

  /// No description provided for @errorExport.
  ///
  /// In ko, this message translates to:
  /// **'데이터 내보내기 실패'**
  String get errorExport;

  /// No description provided for @errorRefine.
  ///
  /// In ko, this message translates to:
  /// **'데이터 정제 실패'**
  String get errorRefine;

  /// No description provided for @errorOccurred.
  ///
  /// In ko, this message translates to:
  /// **'오류 발생: {message}'**
  String errorOccurred(String message);

  /// No description provided for @metaReportNo.
  ///
  /// In ko, this message translates to:
  /// **'신고번호: {reportNo}'**
  String metaReportNo(String reportNo);

  /// No description provided for @metaMainIngredients.
  ///
  /// In ko, this message translates to:
  /// **'주원료: '**
  String get metaMainIngredients;

  /// No description provided for @detailTitle.
  ///
  /// In ko, this message translates to:
  /// **'제품 상세 정보'**
  String get detailTitle;

  /// No description provided for @detailTabFuncRaw.
  ///
  /// In ko, this message translates to:
  /// **'기능성 원료'**
  String get detailTabFuncRaw;

  /// No description provided for @detailTabEtcRaw.
  ///
  /// In ko, this message translates to:
  /// **'기타 원자재'**
  String get detailTabEtcRaw;

  /// No description provided for @detailTabCapRaw.
  ///
  /// In ko, this message translates to:
  /// **'복합/캡슐'**
  String get detailTabCapRaw;

  /// No description provided for @detailSectionBasic.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보'**
  String get detailSectionBasic;

  /// No description provided for @detailLabelCompany.
  ///
  /// In ko, this message translates to:
  /// **'업소명'**
  String get detailLabelCompany;

  /// No description provided for @detailLabelReportNo.
  ///
  /// In ko, this message translates to:
  /// **'신고번호'**
  String get detailLabelReportNo;

  /// No description provided for @detailLabelRegDate.
  ///
  /// In ko, this message translates to:
  /// **'등록일자'**
  String get detailLabelRegDate;

  /// No description provided for @detailLabelExpireDate.
  ///
  /// In ko, this message translates to:
  /// **'소비기한'**
  String get detailLabelExpireDate;

  /// No description provided for @detailLabelAppearance.
  ///
  /// In ko, this message translates to:
  /// **'성상'**
  String get detailLabelAppearance;

  /// No description provided for @detailLabelForm.
  ///
  /// In ko, this message translates to:
  /// **'제품형태'**
  String get detailLabelForm;

  /// No description provided for @detailSectionPacking.
  ///
  /// In ko, this message translates to:
  /// **'포장 정보'**
  String get detailSectionPacking;

  /// No description provided for @detailLabelPackMaterial.
  ///
  /// In ko, this message translates to:
  /// **'포장재질'**
  String get detailLabelPackMaterial;

  /// No description provided for @detailLabelPackMethod.
  ///
  /// In ko, this message translates to:
  /// **'포장방법'**
  String get detailLabelPackMethod;

  /// No description provided for @detailSectionIntake.
  ///
  /// In ko, this message translates to:
  /// **'섭취량 및 섭취방법'**
  String get detailSectionIntake;

  /// No description provided for @detailSectionFunc.
  ///
  /// In ko, this message translates to:
  /// **'기능성 내용'**
  String get detailSectionFunc;

  /// No description provided for @detailSectionStandard.
  ///
  /// In ko, this message translates to:
  /// **'기준 및 규격'**
  String get detailSectionStandard;

  /// No description provided for @detailSectionCaution.
  ///
  /// In ko, this message translates to:
  /// **'주의사항 및 보관'**
  String get detailSectionCaution;

  /// No description provided for @detailLabelCautionIntake.
  ///
  /// In ko, this message translates to:
  /// **'섭취 시 주의사항'**
  String get detailLabelCautionIntake;

  /// No description provided for @detailLabelCautionStorage.
  ///
  /// In ko, this message translates to:
  /// **'보존 및 유통기준'**
  String get detailLabelCautionStorage;

  /// No description provided for @detailSectionIngredients.
  ///
  /// In ko, this message translates to:
  /// **'원료 정보'**
  String get detailSectionIngredients;

  /// No description provided for @detailLabelRawMaterialsSearchable.
  ///
  /// In ko, this message translates to:
  /// **'원재료 정보 (검색 가능)'**
  String get detailLabelRawMaterialsSearchable;

  /// No description provided for @detailSelectedCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 선택됨'**
  String detailSelectedCount(int count);

  /// No description provided for @detailSectionRawMaterialsReport.
  ///
  /// In ko, this message translates to:
  /// **'품목제조신고 원재료'**
  String get detailSectionRawMaterialsReport;

  /// No description provided for @detailFabSearchWithIngredients.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 원료로 검색'**
  String detailFabSearchWithIngredients(int count);

  /// No description provided for @settingsRefiningTitle.
  ///
  /// In ko, this message translates to:
  /// **'원재료 정제 중'**
  String get settingsRefiningTitle;

  /// No description provided for @settingsRefiningComplete.
  ///
  /// In ko, this message translates to:
  /// **'원재료 재정제가 완료되었습니다.'**
  String get settingsRefiningComplete;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In ko, this message translates to:
  /// **'앱 테마'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In ko, this message translates to:
  /// **'라이트 모드'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSelectTitle.
  ///
  /// In ko, this message translates to:
  /// **'테마 선택'**
  String get settingsThemeSelectTitle;

  /// No description provided for @settingsUpdateParamsTitle.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 안내 주기'**
  String get settingsUpdateParamsTitle;

  /// No description provided for @settingsUpdateParamsDesc.
  ///
  /// In ko, this message translates to:
  /// **'데이터 업데이트 필요 여부를 체크하는 주기입니다.'**
  String get settingsUpdateParamsDesc;

  /// No description provided for @updateIntervalDays.
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String updateIntervalDays(int days);

  /// No description provided for @settingsDevToolsTitle.
  ///
  /// In ko, this message translates to:
  /// **'개발자 도구 (테스트용)'**
  String get settingsDevToolsTitle;

  /// No description provided for @settingsDevForceExpire.
  ///
  /// In ko, this message translates to:
  /// **'강제 업데이트 만료 처리'**
  String get settingsDevForceExpire;

  /// No description provided for @settingsDevForceExpireDesc.
  ///
  /// In ko, this message translates to:
  /// **'마지막 업데이트 시간을 30일 전으로 되돌립니다.\n앱 재시작 시 업데이트 팝업을 테스트할 수 있습니다.'**
  String get settingsDevForceExpireDesc;

  /// No description provided for @settingsDevForceExpireSuccess.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 시간이 만료되었습니다. 앱을 재시작하세요.'**
  String get settingsDevForceExpireSuccess;

  /// No description provided for @settingsExportTitle.
  ///
  /// In ko, this message translates to:
  /// **'데이터 엑셀 내보내기'**
  String get settingsExportTitle;

  /// No description provided for @settingsExportDesc.
  ///
  /// In ko, this message translates to:
  /// **'저장된 식품 정보를 엑셀 파일로 저장하거나 공유합니다.'**
  String get settingsExportDesc;

  /// No description provided for @settingsExporting.
  ///
  /// In ko, this message translates to:
  /// **'엑셀 파일 생성 중...'**
  String get settingsExporting;

  /// No description provided for @settingsErrorExport.
  ///
  /// In ko, this message translates to:
  /// **'데이터 내보내기 실패: {error}'**
  String settingsErrorExport(String error);

  /// No description provided for @settingsErrorRefine.
  ///
  /// In ko, this message translates to:
  /// **'데이터 재정제 실패: {error}'**
  String settingsErrorRefine(String error);

  /// No description provided for @ruleUpdatesAndRefinement.
  ///
  /// In ko, this message translates to:
  /// **'정제 규칙 업데이트 및 재정제'**
  String get ruleUpdatesAndRefinement;

  /// No description provided for @ruleUpdatesDescWithTime.
  ///
  /// In ko, this message translates to:
  /// **'최신 규칙으로 원재료명을 다시 정리합니다.\n최종 업데이트: {time}'**
  String ruleUpdatesDescWithTime(String time);

  /// No description provided for @ruleUpdatesDesc.
  ///
  /// In ko, this message translates to:
  /// **'최신 규칙으로 원재료명을 다시 정리합니다.'**
  String get ruleUpdatesDesc;

  /// No description provided for @apiLastUpdate.
  ///
  /// In ko, this message translates to:
  /// **'최종 업데이트: {time}'**
  String apiLastUpdate(String time);

  /// No description provided for @apiParamsTitle.
  ///
  /// In ko, this message translates to:
  /// **'API 설정'**
  String get apiParamsTitle;

  /// No description provided for @apiGuide1.
  ///
  /// In ko, this message translates to:
  /// **'식품안전나라 API 키를 입력해주세요.'**
  String get apiGuide1;

  /// No description provided for @apiGuide2.
  ///
  /// In ko, this message translates to:
  /// **'공공데이터포털에서 발급받은 키가 필요합니다.'**
  String get apiGuide2;

  /// No description provided for @apiInputLabel.
  ///
  /// In ko, this message translates to:
  /// **'API 인증키'**
  String get apiInputLabel;

  /// No description provided for @apiInputHint.
  ///
  /// In ko, this message translates to:
  /// **'인증키를 입력하세요'**
  String get apiInputHint;

  /// No description provided for @apiInputError.
  ///
  /// In ko, this message translates to:
  /// **'키를 입력해주세요'**
  String get apiInputError;

  /// No description provided for @apiSaveButton.
  ///
  /// In ko, this message translates to:
  /// **'저장하고 시작하기'**
  String get apiSaveButton;

  /// No description provided for @favoritesTitle.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기가 없습니다'**
  String get favoritesEmpty;

  /// No description provided for @favoritesEmptyGuide.
  ///
  /// In ko, this message translates to:
  /// **'상세 화면에서 하트 아이콘을 눌러\n즐겨찾기에 추가하세요'**
  String get favoritesEmptyGuide;

  /// No description provided for @favoritesErrorTitle.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get favoritesErrorTitle;

  /// No description provided for @favoritesViewDetail.
  ///
  /// In ko, this message translates to:
  /// **'{name} 상세 보기'**
  String favoritesViewDetail(String name);

  /// No description provided for @updateNeededTitle.
  ///
  /// In ko, this message translates to:
  /// **'데이터 업데이트 필요'**
  String get updateNeededTitle;

  /// No description provided for @updateNeededContent.
  ///
  /// In ko, this message translates to:
  /// **'마지막 업데이트로부터 30일이 지났습니다.\n최신 데이터로 업데이트하시겠습니까?'**
  String get updateNeededContent;

  /// No description provided for @updateLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get updateLater;

  /// No description provided for @updateNow.
  ///
  /// In ko, this message translates to:
  /// **'업데이트'**
  String get updateNow;

  /// No description provided for @downloadTitle.
  ///
  /// In ko, this message translates to:
  /// **'데이터 다운로드'**
  String get downloadTitle;

  /// No description provided for @downloadCompletePercent.
  ///
  /// In ko, this message translates to:
  /// **'{percent}% 완료'**
  String downloadCompletePercent(int percent);

  /// No description provided for @downloadRunInBackground.
  ///
  /// In ko, this message translates to:
  /// **'백그라운드에서 계속하기'**
  String get downloadRunInBackground;

  /// No description provided for @downloadStart.
  ///
  /// In ko, this message translates to:
  /// **'다운로드 시작'**
  String get downloadStart;

  /// No description provided for @downloadingTitle.
  ///
  /// In ko, this message translates to:
  /// **'최신 데이터를 받아옵니다.'**
  String get downloadingTitle;

  /// No description provided for @downloadingDesc.
  ///
  /// In ko, this message translates to:
  /// **'데이터가 많아 시간이 소요될 수 있습니다.\n와이파이 환경을 권장합니다.'**
  String get downloadingDesc;

  /// No description provided for @favoriteProductNotFound.
  ///
  /// In ko, this message translates to:
  /// **'제품 정보를 찾을 수 없습니다'**
  String get favoriteProductNotFound;

  /// No description provided for @errorInvalidArgs.
  ///
  /// In ko, this message translates to:
  /// **'잘못된 접근입니다'**
  String get errorInvalidArgs;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
