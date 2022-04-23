import 'package:async/async.dart';
import 'package:fruit/model/fruit.dart';
import 'package:fruit/datasource/FruitDataSource.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class FruitRepository {
  final FruitDataSource _fruitDataSource;

  FruitRepository(this._fruitDataSource);

  Future<Result<List<Fruit>>> fetchItems({
    required bool imageReference,
    required String referenceId,
  }) {
    return _fruitDataSource.getItems(
      imageReference: imageReference,
      referenceId: referenceId,
    );
  }
}
