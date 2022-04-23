import 'package:async/async.dart';
import 'package:fruit/model/fruit.dart';
import 'package:fruit/network/api/fruit_api.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class FruitDataSource {
  final FruitApi _fruitApi;

  FruitDataSource(this._fruitApi);

  Future<Result<List<Fruit>>> getItems({
    required bool imageReference,
    required String referenceId,
  }) async {
    final result = await _fruitApi.getData(
      imageReference: imageReference,
      referenceId: referenceId,
    );

    final error = result.asError?.error;
    if (error != null) {
      return Result.error(error);
    }

    final data = result.asValue?.value.data;

    final fruits = data?.fruits
        .fold<Map<String, Fruit>>({}, (
          map,
          element,
        ) {
          Fruit? item = map[element.name];
          if (item == null) {
            item = Fruit(
              name: element.name,
              image: data.imagesReferences[element.name] ?? '',
              quantity: 1,
              price: element.price,
            );
            map[element.name] = item;
          } else {
            item.quantity += 1;
            item.price += element.price;
          }
          return map;
        })
        .values
        .toList();

    return Result.value(fruits ?? []);
  }
}
