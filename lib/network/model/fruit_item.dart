import 'package:flutter/foundation.dart';

@immutable
class FruitItem {

  const FruitItem({
    required this.name,
    required this.price,
  });

  final String name;
  final int price;

  factory FruitItem.fromJson(Map<String,dynamic> json) => FruitItem(
    name: json['name'].toString(),
    price: json['price'] as int
  );
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price
  };

  FruitItem clone() => FruitItem(
    name: name,
    price: price
  );


  FruitItem copyWith({
    String? name,
    int? price
  }) => FruitItem(
    name: name ?? this.name,
    price: price ?? this.price,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is FruitItem && name == other.name && price == other.price;

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
