part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<FoodItem> foods;
  final String query;
  const SearchLoaded(this.foods, {this.query = ''});
  @override
  List<Object> get props => [foods, query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object> get props => [message];
}
