import 'package:crypto_tracker/core/network/network_info.dart';
import 'package:crypto_tracker/features/data/datasource/crypto_local_datasource.dart';
import 'package:crypto_tracker/features/data/datasource/crypto_remote_datasource.dart';
import 'package:crypto_tracker/features/domain/entity/crypto.dart';
import 'package:crypto_tracker/features/domain/repository/crypto_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final CryptoLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  CryptoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Crypto>>> getCoins(int page) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteCoins = await remoteDataSource(page);
        await localDatasource.cacheCoins(remoteCoins);

        return Right(remoteCoins);
      } catch (e) {
        return Left(ServerFailure("Erro ao buscar dados remotos"));
      }
    } else {
      try {
        final localCoins = await localDatasource.getCachedCoins();

        if (localCoins.isEmpty) {
          return Left(NetworkFailure('Erro de conexão'));
        }

        return Right(localCoins);
      } catch (e) {
        return Left(NetworkFailure('Erro ao acessar dados remotos e local'));
      }
    }
  }
}
