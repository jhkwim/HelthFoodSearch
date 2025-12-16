part of 'ingredient_search_cubit.dart';

enum IngredientSearchStatus { initial, loading, loaded, error }

class IngredientSearchState extends Equatable {
  final List<String> selectedIngredients;
  final List<FoodItem> searchResults;
  final List<Ingredient> suggestions;
  final bool matchAll;
  final IngredientSearchStatus status;
  final String? errorMessage;

  const IngredientSearchState({
    this.selectedIngredients = const [],
    this.searchResults = const [],
    this.suggestions = const [],
    this.matchAll = false,
    this.status = IngredientSearchStatus.initial,
    this.errorMessage,
  });

  IngredientSearchState copyWith({
    List<String>? selectedIngredients,
    List<FoodItem>? searchResults,
    List<Ingredient>? suggestions,
    bool? matchAll,
    IngredientSearchStatus? status,
    String? errorMessage,
  }) {
    return IngredientSearchState(
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      searchResults: searchResults ?? this.searchResults,
      suggestions: suggestions ?? this.suggestions,
      matchAll: matchAll ?? this.matchAll,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedIngredients, searchResults, suggestions, matchAll, status, errorMessage];
}
