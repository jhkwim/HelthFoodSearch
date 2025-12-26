// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Health Food Search';

  @override
  String get navProductSearch => 'Product Search';

  @override
  String get navIngredientSearch => 'Ingredient Search';

  @override
  String get searchHintProduct => 'Enter product name';

  @override
  String get searchHintIngredient => 'Enter ingredient name';

  @override
  String get searchEmptyGuide => 'Select a product from the list on the left';

  @override
  String searchResultCount(Object count) {
    return '$count results found';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDisplaySection => 'Display';

  @override
  String get settingsLargeText => 'Large Text Mode';

  @override
  String get settingsLargeTextDesc => 'Increases text size throughout the app.';

  @override
  String get settingsApiSection => 'API Settings';

  @override
  String get settingsApiKey => 'API Key';

  @override
  String get settingsDataSection => 'Data Management';

  @override
  String get settingsDataRefresh => 'Redownload Data';

  @override
  String get settingsDataRefreshDesc =>
      'Fetch the latest data from the server.';

  @override
  String settingsDataSaved(String count) {
    return 'Saved Data: $count items';
  }

  @override
  String settingsDataSavedWithSize(String count, String size) {
    return 'Saved Data: $count items ($size MB)';
  }

  @override
  String get settingsDataDelete => 'Delete Data';

  @override
  String get settingsDataDeleteDesc => 'Delete all saved data.';

  @override
  String get settingsDataDeleteConfirmTitle => 'Delete Data';

  @override
  String get settingsDataDeleteConfirmContent =>
      'Are you sure you want to delete all data?';

  @override
  String get settingsDataDeleteCancel => 'Cancel';

  @override
  String get settingsDataDeleteConfirm => 'Delete';

  @override
  String get settingsDataRefreshNotice =>
      'Data will be refreshed upon redownloading.';

  @override
  String get settingsAppInfoSection => 'App Info';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLoading => 'Loading...';

  @override
  String get settingsNotSet => 'Not Set';

  @override
  String syncProgress(String percent) {
    return 'Downloading... ($percent%) - Search Available';
  }

  @override
  String get searchProductHintExample => 'Ex: Vitamin';

  @override
  String get searchProductEmpty => 'No results found.';

  @override
  String get searchProductInitial => 'Enter a product name to search.';

  @override
  String get searchIngredientLabel => 'Add Ingredient';

  @override
  String get searchIngredientHintExample =>
      'Enter ingredient (Ex: Red Ginseng)';

  @override
  String get searchModeLabel => 'Search Mode:';

  @override
  String get searchModeInclude => 'Include (+α)';

  @override
  String get searchModeExclusive => 'Exclusive (Only)';

  @override
  String get searchIngredientEmptyResult => 'No products match your criteria.';

  @override
  String get searchIngredientInitial => 'Add ingredients to start searching.';

  @override
  String errorOccurred(String message) {
    return 'Error: $message';
  }

  @override
  String metaReportNo(String reportNo) {
    return 'Report No: $reportNo';
  }

  @override
  String get metaMainIngredients => 'Main Ingredients: ';

  @override
  String get detailTitle => 'Product Details';

  @override
  String get detailTabFuncRaw => 'Functional Ingredients';

  @override
  String get detailTabEtcRaw => 'Other Materials';

  @override
  String get detailTabCapRaw => 'Capsule/Composite';

  @override
  String get detailSectionBasic => 'Basic Info';

  @override
  String get detailLabelCompany => 'Company';

  @override
  String get detailLabelReportNo => 'Report No';

  @override
  String get detailLabelRegDate => 'Reg. Date';

  @override
  String get detailLabelExpireDate => 'Expiration Date';

  @override
  String get detailLabelAppearance => 'Appearance';

  @override
  String get detailLabelForm => 'Form';

  @override
  String get detailSectionPacking => 'Packaging Info';

  @override
  String get detailLabelPackMaterial => 'Material';

  @override
  String get detailLabelPackMethod => 'Method';

  @override
  String get detailSectionIntake => 'Intake Info';

  @override
  String get detailSectionFunc => 'Functions';

  @override
  String get detailSectionStandard => 'Standards';

  @override
  String get detailSectionCaution => 'Cautions';

  @override
  String get detailLabelCautionIntake => 'Intake Cautions';

  @override
  String get detailLabelCautionStorage => 'Storage Cautions';

  @override
  String get detailSectionIngredients => 'Ingredients';

  @override
  String get detailLabelRawMaterialsSearchable => 'Ingredients (Searchable)';

  @override
  String detailSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get detailSectionRawMaterialsReport => 'Reported Ingredients';

  @override
  String detailFabSearchWithIngredients(int count) {
    return 'Search with $count ingredients';
  }

  @override
  String get settingsRefiningTitle => 'Refining Ingredients';

  @override
  String get settingsRefiningComplete => 'Ingredient refinement completed.';

  @override
  String get settingsThemeTitle => 'App Theme';

  @override
  String get settingsThemeSystem => 'System Default';

  @override
  String get settingsThemeLight => 'Light Mode';

  @override
  String get settingsThemeDark => 'Dark Mode';

  @override
  String get settingsThemeSelectTitle => 'Select Theme';

  @override
  String get settingsUpdateParamsTitle => 'Update Notification Interval';

  @override
  String get settingsUpdateParamsDesc => 'Frequency to check for data updates.';

  @override
  String updateIntervalDays(int days) {
    return '$days Days';
  }

  @override
  String get settingsDevToolsTitle => 'Developer Tools';

  @override
  String get settingsDevForceExpire => 'Force Update Expiration';

  @override
  String get settingsDevForceExpireDesc =>
      'Resets last update time to 30 days ago.\nTests update popup on restart.';

  @override
  String get settingsDevForceExpireSuccess =>
      'Update expired. Please restart the app.';

  @override
  String get settingsExportTitle => 'Export to Excel';

  @override
  String get settingsExportDesc => 'Save or share food data as an Excel file.';

  @override
  String get settingsExporting => 'Generating Excel file...';

  @override
  String settingsErrorExport(String error) {
    return 'Export failed: $error';
  }

  @override
  String settingsErrorRefine(String error) {
    return 'Refinement failed: $error';
  }

  @override
  String get ruleUpdatesAndRefinement => 'Update Rules & Refine';

  @override
  String ruleUpdatesDescWithTime(String time) {
    return 'Re-refines ingredients with latest rules.\nLast Updated: $time';
  }

  @override
  String get ruleUpdatesDesc => 'Re-refines ingredients with latest rules.';

  @override
  String apiLastUpdate(String time) {
    return 'Final Update: $time';
  }

  @override
  String get apiParamsTitle => 'API Settings';

  @override
  String get apiGuide1 => 'Please enter your Food Safety Korea API Key.';

  @override
  String get apiGuide2 => 'You need a key issued from the Public Data Portal.';

  @override
  String get apiInputLabel => 'API Key';

  @override
  String get apiInputHint => 'Enter API Key';

  @override
  String get apiInputError => 'Please enter a key';

  @override
  String get apiSaveButton => 'Save and Start';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get favoritesEmptyGuide =>
      'Tap the heart icon on a product detail\nto add to favorites';

  @override
  String get favoritesErrorTitle => 'An error occurred';

  @override
  String favoritesViewDetail(String name) {
    return 'View details for $name';
  }

  @override
  String get updateNeededTitle => 'Update Required';

  @override
  String get updateNeededContent =>
      'It has been over 30 days since the last update.\nWould you like to update to the latest data?';

  @override
  String get updateLater => 'Later';

  @override
  String get updateNow => 'Update Now';

  @override
  String get downloadTitle => 'Download Data';

  @override
  String downloadCompletePercent(int percent) {
    return '$percent% Complete';
  }

  @override
  String get downloadRunInBackground => 'Continue in Background';

  @override
  String get downloadStart => 'Start Download';

  @override
  String get downloadingTitle => 'Downloading Latest Data...';

  @override
  String get downloadingDesc =>
      'This may take some time depending on data size.\nWi-Fi connection is recommended.';

  @override
  String get favoriteProductNotFound => 'Product information not found.';

  @override
  String get errorInvalidArgs => 'Invalid Arguments';
}
