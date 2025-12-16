import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/usecases/search_food_by_ingredients_usecase.dart';
import '../../domain/usecases/get_suggested_ingredients_usecase.dart';

part 'ingredient_search_state.dart';

@injectable
class IngredientSearchCubit extends Cubit<IngredientSearchState> {
  final SearchFoodByIngredientsUseCase searchFoodByIngredientsUseCase;
  final GetSuggestedIngredientsUseCase getSuggestedIngredientsUseCase;

  IngredientSearchCubit(
    this.searchFoodByIngredientsUseCase,
    this.getSuggestedIngredientsUseCase,
  ) : super(const IngredientSearchState());

  void addIngredient(String ingredient) {
    if (ingredient.trim().isEmpty) return;
    if (state.selectedIngredients.contains(ingredient)) return;
    
    final newIngredients = List<String>.from(state.selectedIngredients)..add(ingredient);
    emit(state.copyWith(selectedIngredients: newIngredients, searchResults: [], status: IngredientSearchStatus.initial));
  }

  void removeIngredient(String ingredient) {
    final newIngredients = List<String>.from(state.selectedIngredients)..remove(ingredient);
    emit(state.copyWith(selectedIngredients: newIngredients, searchResults: [], status: IngredientSearchStatus.initial));
  }
  
  void toggleMatchAll(bool value) {
    emit(state.copyWith(matchAll: value));
  }

  Future<void> search() async {
    if (state.selectedIngredients.isEmpty) return;

    emit(state.copyWith(status: IngredientSearchStatus.loading));
    
    final result = await searchFoodByIngredientsUseCase(
      SearchFoodByIngredientsParams(
        ingredients: state.selectedIngredients,
        matchAll: state.matchAll,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(status: IngredientSearchStatus.error, errorMessage: failure.message)),
      (foods) => emit(state.copyWith(status: IngredientSearchStatus.loaded, searchResults: foods)),
    );
  }

  Future<void> updateSuggestions(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }

    // Debounce can be handled in UI or here with Stream. For simplicity, we call directly.
    final result = await getSuggestedIngredientsUseCase(query);
    result.fold(
      (failure) => null, // Ignore errors for suggestion
      (suggestions) => emit(state.copyWith(suggestions: suggestions)),
    );
  }
}
