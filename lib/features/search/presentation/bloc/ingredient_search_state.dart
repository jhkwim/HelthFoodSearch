part of 'ingredient_search_cubit.dart';

enum IngredientSearchStatus { initial, loading, loaded, error }

class IngredientSearchState extends Equatable {
  final List<String> selectedIngredients;
  final List<FoodItem> searchResults;
  final List<Ingredient> suggestions;
  final IngredientSearchType searchType;
  final IngredientSearchStatus status;
  final String? errorMessage;

  const IngredientSearchState({
    this.selectedIngredients = const [],
    this.searchResults = const [],
    this.suggestions = const [],
    this.searchType = IngredientSearchType.include,
    this.status = IngredientSearchStatus.initial,
    this.errorMessage,
  });

  IngredientSearchState copyWith({
    List<String>? selectedIngredients,
    List<FoodItem>? searchResults,
    List<Ingredient>? suggestions,
    IngredientSearchType? searchType,
    IngredientSearchStatus? status,
    String? errorMessage,
  }) {
    return IngredientSearchState(
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      searchResults: searchResults ?? this.searchResults,
      suggestions: suggestions ?? this.suggestions,
      searchType: searchType ?? this.searchType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedIngredients, searchResults, suggestions, searchType, status, errorMessage];
}
