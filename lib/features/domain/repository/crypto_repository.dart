import 'package:crypto_tracker/features/domain/entity/crypto.dart';

abstract class CryptoRepository {
  Future<List<Crypto>> getCoins(int page);
}
