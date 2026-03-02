import 'package:crypto_tracker/features/data/model/crypto_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CryptoLocalDatasource {
  Future<void> cacheCoins(List<CryptoModel> coins);
  Future<List<CryptoModel>> getCachedCoins();
  Future<bool> isCachedValid();
}

class CryptoLocalDatasourceImpl implements CryptoLocalDatasource {
  final Box box;

  static const cacheKey = 'CACHED_COINS';
  static const cacheTimeKey = 'CACHE_TIME';
  static const cacheTTL = Duration(minutes: 10);

  CryptoLocalDatasourceImpl(this.box);

  @override
  Future<void> cacheCoins(List<CryptoModel> coins) async {
    await box.put(cacheKey, coins.map((e) => e.toJson()).toList());
    await box.put(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<List<CryptoModel>> getCachedCoins() async {
    final cache = await box.get('CACHED_COINS');

    if (cache == null) return [];

    return (cache as List).map((json) => CryptoModel.fromJson(json)).toList();
  }

  @override
  Future<bool> isCachedValid() async {
    final timestamp = await box.get(cacheTimeKey);
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime) < cacheTTL;
  }
}
