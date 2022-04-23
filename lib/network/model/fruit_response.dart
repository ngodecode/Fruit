import 'package:flutter/foundation.dart';

import 'fruit_item.dart';

@immutable
class FruitResponse {

  const FruitResponse({
    required this.message,
    required this.code,
    required this.data,
  });

  final String message;
  final int code;
  final Data data;

  factory FruitResponse.fromJson(Map<String,dynamic> json) => FruitResponse(
    message: json['message'].toString(),
    code: json['code'] as int,
    data: Data.fromJson(json['data'] as Map<String, dynamic>)
  );
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
    'data': data.toJson()
  };

  FruitResponse clone() => FruitResponse(
    message: message,
    code: code,
    data: data.clone()
  );


  FruitResponse copyWith({
    String? message,
    int? code,
    Data? data
  }) => FruitResponse(
    message: message ?? this.message,
    code: code ?? this.code,
    data: data ?? this.data,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is FruitResponse && message == other.message && code == other.code && data == other.data;

  @override
  int get hashCode => message.hashCode ^ code.hashCode ^ data.hashCode;
}

@immutable
class Data {

  const Data({
    required this.imagesReferences,
    required this.fruits,
  });

  final Map<String, dynamic> imagesReferences;
  final List<FruitItem> fruits;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    imagesReferences: json['imagesReferences'] as Map<String, dynamic>,
    fruits: (json['fruits'] as List? ?? []).map((e) => FruitItem.fromJson(e as Map<String, dynamic>)).toList()
  );
  
  Map<String, dynamic> toJson() => {
    'imagesReferences': imagesReferences,
    'fruits': fruits.map((e) => e.toJson()).toList()
  };

  Data clone() => Data(
    imagesReferences: imagesReferences,
    fruits: fruits.map((e) => e.clone()).toList()
  );


  Data copyWith({
    Map<String, String>? imagesReferences,
    List<FruitItem>? fruits
  }) => Data(
    imagesReferences: imagesReferences ?? this.imagesReferences,
    fruits: fruits ?? this.fruits,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Data && imagesReferences == other.imagesReferences && fruits == other.fruits;

  @override
  int get hashCode => imagesReferences.hashCode ^ fruits.hashCode;
}
