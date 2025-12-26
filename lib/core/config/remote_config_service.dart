import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoteConfigService {
  final Dio _dio;

  // Google Sheet Published CSV URL
  static const String _sheetUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vT7xbf7_DLVA160DrPxd-BWo_aDkP91xjiuNnjCXWt6wmJKpzVYBXadshFo8c0uu843QN_weFKIveAd/pub?gid=0&single=true&output=csv';

  RemoteConfigService(this._dio);

  Future<Map<String, String>> fetchRefinementRules() async {
    try {
      final response = await _dio.get<String>(_sheetUrl);

      if (response.statusCode == 200 && response.data != null) {
        return _parseCsv(response.data!);
      }
      return {};
    } catch (e) {
      // Create a specific error log or rethrow if needed
      print('Failed to fetch remote config: $e');
      return {};
    }
  }

  Map<String, String> _parseCsv(String csvContent) {
    final Map<String, String> rules = {};
    final List<String> lines = csvContent.split('\n');

    // Skip header (Assuming 1st row is header: 원본 데이터,정제 데이터)
    // Or check if line contains "원본" or "Refined"
    bool isHeader = true;

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      // Handle simple CSV parsing (aware of potential commas in content, though unlikely for ingredients)
      // Since our data is simple, split(',') is mostly safe unless ingredients have commas.
      // If ingredients have commas, we might need a robust regex or robust splitting.
      // User data didn't show quoted commas.

      final parts = line.split(',');
      if (parts.length < 2) continue;

      if (isHeader) {
        // Simple heuristic to skip header
        if (parts[0].contains('원본') || parts[0].contains('Raw')) {
          isHeader = false;
          continue;
        }
        isHeader = false;
        // If first line isn't header keyword, treat as data?
        // User's CSV output starts with "원본 데이터,정제 데이터".
      }

      final key = parts[0].trim();
      final value = parts[1].trim(); // Take the second column as refine target

      if (key.isNotEmpty && value.isNotEmpty) {
        rules[key] = value;
      }
    }
    return rules;
  }
}
