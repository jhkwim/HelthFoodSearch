import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/usecases/search_food_by_name_usecase.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchFoodByNameUseCase searchFoodByNameUseCase;

  SearchCubit(this.searchFoodByNameUseCase) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await searchFoodByNameUseCase(query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (foods) => emit(SearchLoaded(foods, query: query)),
    );
  }
}
