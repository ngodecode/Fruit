import 'package:dio/dio.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

abstract class NetworkClient {
  Future<Response<T>> post<T>(
    String path, {
    String? data,
    required dynamic Function(String) transformer,
  });
}
