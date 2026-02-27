import 'package:crypto_tracker/features/data/model/crypto_model.dart';

abstract class CryptoRemoteDataSource {
  Future<List<CryptoModel>> call(int page);
}
