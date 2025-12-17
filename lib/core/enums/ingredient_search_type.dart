enum IngredientSearchType {
  /// Products that contain ALL of the selected ingredients (AND logic).
  /// Other ingredients may also be present.
  include,

  /// Products that contain ONLY the selected ingredients.
  /// No other main ingredients should be present.
  exclusive,
}
