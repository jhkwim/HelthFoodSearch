import 'package:bloc/bloc.dart';
import '../../../../core/enums/ingredient_search_type.dart';
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
    // Optimistic update of ingredients list, then search
    emit(state.copyWith(selectedIngredients: newIngredients));
    search();
  }

  void addIngredients(List<String> ingredients) {
    final newIngredients = List<String>.from(state.selectedIngredients);
    bool changed = false;
    for (final ing in ingredients) {
      if (ing.trim().isNotEmpty && !newIngredients.contains(ing)) {
        newIngredients.add(ing);
        changed = true;
      }
    }
    
    if (changed) {
       emit(state.copyWith(selectedIngredients: newIngredients));
       search();
    }
  }

  void removeIngredient(String ingredient) {
    final newIngredients = List<String>.from(state.selectedIngredients)..remove(ingredient);
    emit(state.copyWith(selectedIngredients: newIngredients));
    search();
  }
  
  void setSearchType(IngredientSearchType type) {
    emit(state.copyWith(searchType: type));
    search();
  }

  Future<void> search() async {
    if (state.selectedIngredients.isEmpty) return;

    emit(state.copyWith(status: IngredientSearchStatus.loading));
    
    final result = await searchFoodByIngredientsUseCase(
      SearchFoodByIngredientsParams(
        ingredients: state.selectedIngredients,
        type: state.searchType,
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
