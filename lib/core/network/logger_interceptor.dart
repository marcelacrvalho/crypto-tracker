import 'dart:developer';

import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("=== REQUEST ===");
    log('${options.method} ${options.uri}');
    log('Query: ${options.queryParameters}');
    log('Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log("=== RESPONSE ===");
    log(
      '${response.requestOptions.method} ${response.requestOptions.uri} '
      '[${response.statusCode}]',
    );
    log('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("=== ERROR ===");
    log(
      '${err.requestOptions.method} ${err.requestOptions.uri} '
      '[${err.response?.statusCode ?? "NO_STATUS"}]',
    );
    log('Message: ${err.message}');
    if (err.response?.data != null) {
      log('Error data: ${err.response?.data}');
    }
    handler.next(err);
  }
}
