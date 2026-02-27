import 'package:crypto_tracker/features/data/model/crypto_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CryptoLocalDatasource {
  Future<void> cacheCoins(List<CryptoModel> coins);
  Future<List<CryptoModel>> getCachedCoins();
}

class CryptoLocalDatasourceImpl implements CryptoLocalDatasource {
  final Box box;

  CryptoLocalDatasourceImpl(this.box);

  @override
  Future<void> cacheCoins(List<CryptoModel> coins) async {
    await box.put('CACHED_COINS', coins.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<CryptoModel>> getCachedCoins() async {
    final cache = await box.get('CACHED_COINS');

    if (cache == null) return [];

    return (cache as List).map((json) => CryptoModel.fromJson(json)).toList();
  }
}
