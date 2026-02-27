import 'package:crypto_tracker/features/data/datasource/crypto_datasource.dart';
import 'package:crypto_tracker/features/domain/entity/crypto.dart';
import 'package:crypto_tracker/features/domain/repository/crypto_repository.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource _dataSource;

  CryptoRepositoryImpl(this._dataSource);

  @override
  Future<List<Crypto>> getCoins(int page) async {
    return await _dataSource(page);
  }
}
