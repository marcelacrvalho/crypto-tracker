import 'package:crypto_tracker/core/error/failure.dart';
import 'package:crypto_tracker/features/domain/entity/crypto.dart';
import 'package:crypto_tracker/features/domain/repository/crypto_repository.dart';
import 'package:dartz/dartz.dart';

class GetCoins {
  final CryptoRepository repository;

  GetCoins(this.repository);

  Future<Either<Failure, List<Crypto>>> call(int page) {
    return repository.getCoins(page);
  }
}
