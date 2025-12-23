class IngredientRefiner {
  static final RegExp _parenthesesPattern = RegExp(r'\(.*?\)|\[.*?\]');

  // Hardcoded replacement dictionary provided by user
  static const Map<String, String> _replacements = {
    // 1. 키토산 Group -> 키토산
    '키토산/키토올리고당': '키토산',
    '키토산제품': '키토산',
    '키토올리고당': '키토산',
    '키토올리고당제품': '키토산',
    
    // 2. 차전자피 Group -> 차전자피식이섬유
    '차전자피식이섬유': '차전자피식이섬유', // Self-mapping for clarity (if refined reduces it?)
    '차전자피': '차전자피식이섬유',
    '차전자피제품': '차전자피식이섬유',
    
    // 3. 이눌린 Group -> 이눌린/치커리추출물
    '이눌린/치커리추출물': '이눌린/치커리추출물',
    '이눌린제품': '이눌린/치커리추출물',
    '이눌린': '이눌린/치커리추출물', // Implied single term also merges? text says "list merged to First Item".
    
    // 4. 식물스테롤 Group -> 식물스테롤
    '식물스테롤/식물스테롤에스테르': '식물스테롤',
    '식물스테롤에스테르제품': '식물스테롤',
    '식물스테롤제품': '식물스테롤',
    '식물스테롤에스테르': '식물스테롤',
    '식물스타놀에스테르': '식물스테롤',
    
    // 5. N-아세틸글루코사민 Group -> N-아세틸글루코사민
    'N-아세틸글루코사민제품': 'N-아세틸글루코사민',
    'N-Acetylglucosamine': 'N-아세틸글루코사민',
    'NAG': 'N-아세틸글루코사민',
    '엔에이지': 'N-아세틸글루코사민',
    
    // Legacy / Others
    '클로렐라제품': '클로렐라',
    '감마리놀렌산함유유지': '감마리놀렌산', 
  };

  /// Refines a raw ingredient string into a clean, searchable keyword.
  static String refine(String raw) {
    if (raw.isEmpty) return '';

    // 1. Remove content within parentheses () and brackets []
    String refined = raw.replaceAll(_parenthesesPattern, '');

    // 2. Remove all whitespace
    refined = refined.replaceAll(RegExp(r'\s+'), '');

    // 3. Dictionary Replacement (Exact Match)
    if (_replacements.containsKey(refined)) {
      return _replacements[refined]!;
    }
    
    // 4. "제품" suffix removal rule (User Req #1)
    // Only if it ends with "제품" and length > 2 (to avoid "제품" itself becoming empty or single char)
    if (refined.endsWith('제품') && refined.length > 2) {
       // "클로렐라제품" -> "클로렐라"
       // Check if trimmed version is in map?
       String trimmed = refined.substring(0, refined.length - 2);
       // Check map again for trimmed version? (Maybe "키토산제품" -> "키토산" is already in map, but "Unknown제품" -> "Unknown")
       // If unique, just return trimmed.
       // But if trimmed matches a key in map? e.g. "키토올리고당제품" -> "키토올리고당" -> Map -> "키토산"
       // Recursive refinement? Or just dual check.
       if (_replacements.containsKey(trimmed)) {
         return _replacements[trimmed]!;
       }
       return trimmed;
    }

    // 5. Special Prefix/Contains Rules (User Req #3)
    // Removed simplistic prefix rules as they conflict with explicit merges above.
    // E.g. "식물스테롤/식물스테롤에스테르" starts with "식물스테롤/", but target is itself, not "식물스테롤".
    // If we map exact match first (which we do at step 3), this step handles unknowns.
    
    // But we need to be careful not to override intended explicit merges.
    // The code structure is: 
    // 1. Parentheses/Space removal -> `refined`
    // 2. Dictionary check FIRST. -> returns immediately.
    // 3. Suffix removal.
    // 4. Prefix check.
    
    // Since dictionary check is step 3 (in code logic above, effectively first match logic),
    // explicit mappings like "식물스테롤/식물스테롤에스테르" -> "식물스테롤/식물스테롤에스테르" will be caught there.
    // The prefix logic below serves as a fallback for standardizing unknown variants?
    // User didn't ask for general prefix standardization, just specific list.
    // So better to remove these dangerous prefixes if not explicitly requested.
    // Or keep them but ensure they don't break the rules.
    
    // "식물스테롤/..." -> "식물스테롤" rule logic was my assumption.
    // User wants "식물스테롤/식물스테롤에스테르" preserved (or mapped to itself).
    // If I keep `if (refined.startsWith('식물스테롤/')) return '식물스테롤';`,
    // and if the input is "식물스테롤/Unknown", it becomes "식물스테롤".
    // This seems safe for UNKNOWN items.
    // KNOWN items are in the map and return early.
    
    // However, "키토산/" might be safe?
    // "이눌린/" might be safe?
    // Let's keep them but comment that specific ones are handled by map.
    
    // Wait, "식물스테롤/식물스테롤에스테르" matches map?
    // `refined` will have no spaces. "식물스테롤/식물스테롤에스테르".
    // Map has it? Yes.
    // So it returns early.
    // "식물스테롤/" prefix logic is unreachable for that specific string.
    
    // So it is safe to leave them or remove them.
    // Removing to be safe and strictly follow user request.
    
    // if (refined.startsWith('식물스테롤/')) return '식물스테롤';
    // if (refined.startsWith('키토산/')) return '키토산';
    // if (refined.startsWith('이눌린/')) return '이눌린';

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
