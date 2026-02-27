import 'dart:convert';
import 'package:crypto_tracker/core/error/app_exceptions.dart';
import 'package:http/http.dart' as http;
import '../model/crypto_model.dart';
import 'crypto_remote_datasource.dart';

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  final http.Client client;

  CryptoRemoteDataSourceImpl(this.client);

  @override
  Future<List<CryptoModel>> call(int page) async {
    final uri = Uri.https('api.coingecko.com', '/api/v3/coins/markets', {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'page': page.toString(),
      'per_page': '20',
    });

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);

      return decoded.map((json) => CryptoModel.fromJson(json)).toList();
    } else if (response.statusCode == 400) {
      throw NotFoundException('Erro 400. Nada encontrado. Verifique o caminho');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(
        'Erro 401. Você não tem autorização para fazer isso',
      );
    } else {
      throw NetworkException('Erro ao buscar dados');
    }
  }
}
