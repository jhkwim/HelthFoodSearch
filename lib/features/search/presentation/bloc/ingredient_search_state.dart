part of 'ingredient_search_cubit.dart';

enum IngredientSearchStatus { initial, loading, loaded, error }

class IngredientSearchState extends Equatable {
  final List<String> selectedIngredients;
  final List<FoodItem> searchResults;
  final List<Ingredient> suggestions;
  final IngredientSearchType searchType;
  final IngredientSearchStatus status;
  final Failure? failure;

  const IngredientSearchState({
    this.selectedIngredients = const [],
    this.searchResults = const [],
    this.suggestions = const [],
    this.searchType = IngredientSearchType.include,
    this.status = IngredientSearchStatus.initial,
    this.failure,
  });

  IngredientSearchState copyWith({
    List<String>? selectedIngredients,
    List<FoodItem>? searchResults,
    List<Ingredient>? suggestions,
    IngredientSearchType? searchType,
    IngredientSearchStatus? status,
    Failure? failure,
  }) {
    return IngredientSearchState(
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      searchResults: searchResults ?? this.searchResults,
      suggestions: suggestions ?? this.suggestions,
      searchType: searchType ?? this.searchType,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    selectedIngredients,
    searchResults,
    suggestions,
    searchType,
    status,
    failure,
  ];
}
