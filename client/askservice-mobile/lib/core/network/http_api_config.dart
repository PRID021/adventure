import 'package:dio/dio.dart';

abstract class HttpApiConfig {
  final String path;

  HttpApiConfig({required this.path});

  Dio createDio();
}
