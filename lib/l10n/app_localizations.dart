import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ko')];

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
      <String>['ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
