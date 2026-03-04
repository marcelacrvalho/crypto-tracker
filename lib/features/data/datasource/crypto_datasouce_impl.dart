import 'package:dio/dio.dart';
import '../model/crypto_model.dart';
import 'crypto_remote_datasource.dart';

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  final Dio dioClient;

  CryptoRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<CryptoModel>> call(int page) async {
    final response = await dioClient.get(
      'https://api.coingecko.com/api/v3/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'page': page.toString(),
        'per_page': '20',
      },
    );

    final List data = response.data;
    return data.map((json) => CryptoModel.fromJson(json)).toList();
  }
}
