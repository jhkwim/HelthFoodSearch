class IngredientRefiner {
  static final RegExp _parenthesesPattern = RegExp(r'\(.*?\)|\[.*?\]');
  static final RegExp _nonKoreanPattern = RegExp(r'[^\uAC00-\uD7A3\s]+'); // Keep Korean and spaces

  /// Refines a raw ingredient string into a clean, searchable keyword.
  /// e.g. "바나바잎추출물(인도산)" -> "바나바잎추출물" -> (optional: "바나바")
  /// For this version, we will primarily remove parentheses and trim.
  static String refine(String raw) {
    if (raw.isEmpty) return '';

    // 1. Remove content within parentheses () and brackets []
    String refined = raw.replaceAll(_parenthesesPattern, '');

    // 2. Remove all whitespace to deduplicate "A B" and "AB"
    refined = refined.replaceAll(RegExp(r'\s+'), '');

    return refined;
  }

  /// Extracts potentially multiple ingredients if the string is comma-separated,
  /// and refines each of them.
  static List<String> refineAll(String rawList) {
    if (rawList.isEmpty) return [];
    
    return rawList.split(',')
        .map((e) => refine(e))
        .where((e) => e.isNotEmpty && e.length > 1) // Filter out empty or single-char garbage
        .toSet() // Deduplicate
        .toList();
  }
}
