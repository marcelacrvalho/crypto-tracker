import 'package:crypto_tracker/core/error/app_exceptions.dart';
import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      return handler.next(response);
    }

    switch (statusCode) {
      case 400:
        throw NotFoundException("Requisição inválida");
      case 401:
        throw UnauthorizedException(
          "Você não possui autorização para acessar esse conteúdo",
        );
      case 404:
        throw NotFoundException("Não encontrado");
      case 500:
        throw NetworkException("Erro de servidor");
      default:
        throw NetworkException("Erro de rede. Verifique sua conexão");
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    throw NetworkException(err.message ?? "Erro desconhecido");
  }
}
