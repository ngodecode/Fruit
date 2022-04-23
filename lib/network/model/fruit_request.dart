import 'package:flutter/foundation.dart';

@immutable
class FruitRequest {

  const FruitRequest({
    required this.data,
  });

  final ParamData data;

  factory FruitRequest.fromJson(Map<String,dynamic> json) => FruitRequest(
    data: ParamData.fromJson(json['data'] as Map<String, dynamic>)
  );
  
  Map<String, dynamic> toJson() => {
    'data': data.toJson()
  };

  FruitRequest clone() => FruitRequest(
    data: data.clone()
  );


  FruitRequest copyWith({
    ParamData? data
  }) => FruitRequest(
    data: data ?? this.data,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is FruitRequest && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

@immutable
class ParamData {

  const ParamData({
    required this.imageReferences,
    required this.referenceId,
  });

  final bool imageReferences;
  final String referenceId;

  factory ParamData.fromJson(Map<String,dynamic> json) => ParamData(
    imageReferences: json['imageReferences'] as bool,
    referenceId: json['referenceId'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'imageReferences': imageReferences,
    'referenceId': referenceId
  };

  ParamData clone() => ParamData(
    imageReferences: imageReferences,
    referenceId: referenceId
  );


  ParamData copyWith({
    bool? imageReferences,
    String? referenceId
  }) => ParamData(
    imageReferences: imageReferences ?? this.imageReferences,
    referenceId: referenceId ?? this.referenceId,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ParamData && imageReferences == other.imageReferences && referenceId == other.referenceId;

  @override
  int get hashCode => imageReferences.hashCode ^ referenceId.hashCode;
}
