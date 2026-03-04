import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;

  RetryInterceptor({required this.dio, this.retries = 3});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final attempt = (requestOptions.extra['retry_attempt'] as int?) ?? 0;

    final canRetry = attempt < retries && _shouldRetry(err);
    if (!canRetry) {
      return handler.next(err);
    }

    requestOptions.extra['retry_attempt'] = attempt + 1;

    // Backoff simples 1s, 2s, 3s...
    await Future<void>.delayed(Duration(seconds: attempt + 1));

    try {
      final response = await dio.fetch<dynamic>(requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    final type = err.type;
    final statusCode = err.response?.statusCode ?? 0;

    if (type == DioExceptionType.cancel) {
      return false;
    }

    final isTimeoutOrConnectionIssue =
        type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError;

    final isServerError = statusCode >= 500;

    return isTimeoutOrConnectionIssue || isServerError;
  }
}
