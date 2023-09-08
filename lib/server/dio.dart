import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = 'https://bdh.point-dev.nl/api';
  dio.options.headers['Accept'] = 'application/json';

  return dio;
}
