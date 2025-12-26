class IngredientRefiner {
  static final RegExp _parenthesesPattern = RegExp(r'\(.*?\)|\[.*?\]');

  // Hardcoded replacement dictionary provided by user
  static const Map<String, String> _replacements = {
    // 1. 키토산 Group
    '키토산': '키토산/키토올리고당',
    '키토산제품': '키토산/키토올리고당', // Derivative
    '키토올리고당':
        '키토산/키토올리고당', // Should likely also map to target if encountered? User didn't specify but implied group.
    // 2. 식물스테롤 Group
    '식물스테롤': '식물스테롤/식물스테롤에스테르',
    '식물스테롤제품': '식물스테롤/식물스테롤에스테르',
    '식물스타놀에스테르': '식물스테롤/식물스테롤에스테르',
    '식물스테롤에스테르': '식물스테롤/식물스테롤에스테르',

    // 3. 이눌린/치커리추출물 Group
    '치커리추출물': '이눌린/치커리추출물',
    '이눌린': '이눌린/치커리추출물',

    // 4. N-아세틸글루코사민 Group
    'N-Acetylglucosamine': 'N-아세틸글루코사민',
    'N-Acetylglucosamine)': 'N-아세틸글루코사민',
    'NAG(엔에이지': 'N-아세틸글루코사민', // As per specific text
    'NAG': 'N-아세틸글루코사민', // Common var
    '엔에이지': 'N-아세틸글루코사민', // Common var
    'N-아세틸글루코사민제품': 'N-아세틸글루코사민',

    // 5. 곤약감자추출물 Group
    '곤약감자추출분말': '곤약감자추출물',
    '곤약감자추출물분말': '곤약감자추출물',

    // 6. MSM Group
    '엠에스엠(MSM, MSM)': 'MSM(엠에스엠)',
    '엠에스엠(MSM': 'MSM(엠에스엠)',
    'MSM)': 'MSM(엠에스엠)',
    'Methylsulfonylmethane': 'MSM(엠에스엠)',
    '디메틸설폰(Methylsulfonylmethane, 디메틸설폰)': 'MSM(엠에스엠)',
    '디메틸설폰(Methylsulfonylmethane': 'MSM(엠에스엠)',
    '디메틸설폰)': 'MSM(엠에스엠)',
    '엠에스엠': 'MSM(엠에스엠)', // Likely needed
    '디메틸설폰': 'MSM(엠에스엠)', // Likely needed
    // 7. EPA및DHA함유유지 Group
    '오메가-3지방산함유유지': 'EPA및DHA함유유지',

    // 8. 뮤코다당 Group
    '뮤코다당․단백': '뮤코다당․단백', // Normalized form (key match)
    '뮤코다당·단백': '뮤코다당․단백', // Backup
    '뮤코다당.단백': '뮤코다당․단백', // Backup for logic bypass
    '뮤코다당': '뮤코다당․단백',
    '뮤코다당단백': '뮤코다당․단백',

    // 8. 마리골드꽃추출물 Group
    '마리골드추출물': '마리골드꽃추출물',

    // 9. 가르시니아캄보지아추출물 Group
    '가르시니아캄보지아': '가르시니아캄보지아추출물',
    '가르시니아캄보지아껍질추출물HCA-600-SXS': '가르시니아캄보지아추출물',

    // 10. 코엔자임Q10 Group
    '코엔자임큐텐': '코엔자임Q10',

    // Legacy / Others
    '차전자피': '차전자피식이섬유',
    '차전자피제품': '차전자피식이섬유',
    '클로렐라제품': '클로렐라',
    '감마리놀렌산함유유지': '감마리놀렌산',
    '비타민 B1': '비타민B1',
  };

  // Dynamic rules fetched from remote (Google Sheet)
  static Map<String, String> _remoteReplacements = {};

  /// Update dynamic rules from remote config
  static void updateRules(Map<String, String> newRules) {
    if (newRules.isNotEmpty) {
      _remoteReplacements = newRules;
      print('IngredientRefiner: Updated with ${newRules.length} remote rules');
    }
  }

  /// Refines a raw ingredient string into a clean, searchable keyword.
  static String refine(String raw) {
    if (raw.isEmpty) return '';

    // 1. Remove content within parentheses () and brackets []
    String refined = raw.replaceAll(_parenthesesPattern, '');

    // 2. Remove all whitespace
    refined = refined.replaceAll(RegExp(r'\s+'), '');

    // 2.5 Normalize dot separators to '․' (U+2024) or standard '.'
    // The target key uses '․' (U+2024) in the map: '뮤코다당·단백': '뮤코다당․단백'
    // Source appears to use '·' (U+00B7) or '.' (U+002E).
    // Let's normalize all to the key's format '․' to ensure match.
    // Or simpler: Normalize everything to '.' (U+002E) but update the Map Keys to use '.'?
    // User originally provided '뮤코다당․단백' (U+2024?).
    // Let's normalize variants to '․' (One Dot Leader) to match the existing key.
    refined = refined.replaceAll(RegExp(r'[·.・]'), '․');

    // 3.0 Check Remote Dictionary First (Dynamic Coverage)
    if (_remoteReplacements.containsKey(refined)) {
      return _remoteReplacements[refined]!;
    }

    // 3. Dictionary Replacement (Exact Match)
    if (_replacements.containsKey(refined)) {
      return _replacements[refined]!;
    }

    // 4. "제품" suffix removal rule
    if (refined.endsWith('제품') && refined.length > 2) {
      String trimmed = refined.substring(0, refined.length - 2);

      // Check remote first for trimmed version too
      if (_remoteReplacements.containsKey(trimmed)) {
        return _remoteReplacements[trimmed]!;
      }

      if (_replacements.containsKey(trimmed)) {
        return _replacements[trimmed]!;
      }
      return trimmed;
    }

    return refined;
  }

  /// Extracts potentially multiple ingredients if the string is comma-separated,
  /// and refines each of them.
  static List<String> refineAll(String rawList) {
    if (rawList.isEmpty) return [];

    return rawList
        .split(',')
        .map((e) => refine(e))
        .where(
          (e) => e.isNotEmpty,
        ) // Removed length > 1 check to allow '철', '인'
        .toSet() // Deduplicate
        .toList();
  }

  /// Analyzes raw ingredient string and returns a map of {Raw: Refined}
  /// Used for generating verification reports.
  static Map<String, String> analyze(String rawList) {
    if (rawList.isEmpty) return {};

    final Map<String, String> result = {};
    final list = rawList.split(',');

    for (var raw in list) {
      if (raw.trim().isEmpty) continue;

      // We want to show "Raw Fragment" -> "Refined"
      // But `refine` strips parentheses.
      // The user wants to see "키토산제품" -> "키토산".
      // `refine("키토산제품(중국산)")` -> "키토산".
      // Raw Fragment should be "키토산제품(중국산)"? Or just the key part?
      // User example: "키토산제품" -> "키토산".
      // If input is "키토산제품(중국산)", `refine` returns "키토산".
      // Showing "키토산제품(중국산)" -> "키토산" is correct.

      final refined = refine(raw);
      if (refined.isNotEmpty && refined.length > 1) {
        result[raw.trim()] = refined;
      }
    }
    return result;
  }
}
