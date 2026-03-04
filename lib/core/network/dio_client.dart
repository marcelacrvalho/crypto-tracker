import 'package:dio/dio.dart';
import 'app_interceptor.dart';
import 'logger_interceptor.dart';
import 'retry_interceptor.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.coingecko.com/api/v3',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.addAll([
    LoggerInterceptor(),
    RetryInterceptor(dio: dio),
    AppInterceptor(),
  ]);

  return dio;
}
