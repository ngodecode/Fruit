import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:fruit/app/core/network_client.dart';
import 'package:fruit/network/model/fruit_request.dart';
import 'package:fruit/network/model/fruit_response.dart';
import 'package:fruit/network/error/DataError.dart';
import 'package:fruit/network/error/NetworkError.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class FruitApi {

  static const getDataUri = '/challenges/fruits';

  final NetworkClient _networkClient;

  FruitApi(this._networkClient);

  Future<Result<FruitResponse>> getData({
    required bool imageReference,
    required String referenceId,
  }) async {
    final response = await _networkClient.post<FruitResponse>(
      getDataUri,
      data: FruitRequest(
        data: ParamData(
          imageReferences: imageReference,
          referenceId: referenceId,
        ),
      ).toString(),
      transformer: (source) => FruitResponse.fromJson(jsonDecode(source)),
    );

    if (response.statusCode != HttpStatus.ok) {
      return Result.error(NetworkError());
    } else {
      final data = response.data;
      if (data == null) {
        return Result.error(DataError());
      } else {
        return Result.value(data);
      }
    }
  }
}
