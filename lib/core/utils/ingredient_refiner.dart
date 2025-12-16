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

    // 2. Remove specific keywords that might make the term too specific (Optional/Advanced)
    // refined = refined.replaceAll('추출물', ''); 
    // refined = refined.replaceAll('분말', '');
    
    // 3. Trim whitespace
    refined = refined.trim();

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
