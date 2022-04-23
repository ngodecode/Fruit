import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fruit/app/core/network_client.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class AppNetworkClient extends NetworkClient {
  late Dio _dio;

  AppNetworkClient() {
    _dio = Dio(
      BaseOptions(baseUrl: 'http://demo6772422.mockable.io/ta'),
    );
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = jsonDecode;
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    String? data,
    required dynamic Function(String) transformer,
  }) {
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = transformer;
    return _dio.post(path);
  }
}
