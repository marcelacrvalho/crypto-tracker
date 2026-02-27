import 'package:crypto_tracker/features/domain/entity/crypto.dart';
import 'package:crypto_tracker/features/domain/repository/crypto_repository.dart';

abstract class GetCoins {
  final CryptoRepository _repository;

  GetCoins(this._repository);

  Future<List<Crypto>> getCoins(int page) {
    return _repository.getCoins(page);
  }
}
