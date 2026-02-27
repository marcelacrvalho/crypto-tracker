import 'package:crypto_tracker/core/error/failure.dart';
import 'package:crypto_tracker/features/domain/entity/crypto.dart';
import 'package:dartz/dartz.dart';

abstract class CryptoRepository {
  Future<Either<Failure, List<Crypto>>> getCoins(int page);
}
