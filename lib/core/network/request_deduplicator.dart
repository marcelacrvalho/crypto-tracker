import 'dart:async';

import 'package:dio/dio.dart';

class RequestDeduplicator extends Interceptor {
  final Map<String, Completer<Response<dynamic>>> _pendingRequests = {};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final key = _buildRequestKey(options);

    final pending = _pendingRequests[key];
    if (pending != null) {
      try {
        final response = await pending.future;
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      } catch (e) {
        return handler.reject(
          DioException(requestOptions: options, error: e),
        );
      }
    }

    _pendingRequests[key] = Completer<Response<dynamic>>();
    options.extra['dedup_key'] = key;
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final key = response.requestOptions.extra['dedup_key'] as String? ??
        _buildRequestKey(response.requestOptions);

    final completer = _pendingRequests.remove(key);
    if (completer != null && !completer.isCompleted) {
      completer.complete(response);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = err.requestOptions.extra['dedup_key'] as String? ??
        _buildRequestKey(err.requestOptions);

    final completer = _pendingRequests.remove(key);
    if (completer != null && !completer.isCompleted) {
      completer.completeError(err);
    }

    handler.next(err);
  }

  String _buildRequestKey(RequestOptions options) {
    final method = options.method.toUpperCase();
    final uri = options.uri.toString();
    final data = options.data?.toString() ?? '';
    return '$method|$uri|$data';
  }
}
