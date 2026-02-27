class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}
