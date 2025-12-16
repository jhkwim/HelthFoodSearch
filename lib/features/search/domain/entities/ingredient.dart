import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;

  const Ingredient({required this.name});

  @override
  List<Object?> get props => [name];
}
