import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../error/failures.dart';

extension FailureMessage on Failure {
  String toUserMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Pattern matching for specific failures
    if (this is NetworkFailure) {
      return l10n.errorNetwork;
    } else if (this is ServerFailure) {
      return l10n.errorServer;
    } else if (this is CacheFailure) {
      return l10n.errorCache;
    } else if (this is DataParsingFailure) {
      return l10n.errorDataParsing;
    } else if (this is ApiKeyMissingFailure) {
      return l10n.errorApiKeyMissing;
    } else if (this is ExportFailure) {
      return l10n.errorExport;
    } else if (this is RefineFailure) {
      return l10n.errorRefine;
    }

    // For general failures or if message is explicitly meaningful?
    // If we want to fully localize, we should avoid using 'message' directly unless it comes from backend as user msg.
    // However, usually backend errors are technical.
    // For now, let's use a generic error if unknown, or maybe append message for debug builds?
    // But user requirement is "Language Pack".

    return l10n.errorUnknown;
  }
}
