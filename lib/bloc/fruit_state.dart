part of 'fruit_bloc.dart';

@immutable
abstract class FruitState {}

class FruitInitial extends FruitState {}

class Loading extends FruitState {}

class FetchSuccess extends FruitState {
  final List<Fruit> items;

  FetchSuccess({required this.items});
}

class FetchFailed extends FruitState {
  final Object? error;

  FetchFailed({this.error});
}
