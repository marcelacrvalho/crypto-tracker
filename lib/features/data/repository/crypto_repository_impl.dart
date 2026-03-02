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
  @override
  Future<Either<Failure, List<Crypto>>> getCoins(int page) async {
    try {
      final cacheValid = await localDatasource.isCachedValid();

      if (cacheValid) {
        final cachedCoins = await localDatasource.getCachedCoins();
        return Right(cachedCoins);
      }

      final isConnected = await networkInfo.isConnected();

      if (isConnected) {
        final remoteCoins = await remoteDataSource(page);

        await localDatasource.cacheCoins(remoteCoins);

        return Right(remoteCoins);
      }

      final cachedCoins = await localDatasource.getCachedCoins();

      if (cachedCoins.isNotEmpty) {
        return Right(cachedCoins);
      }

      return Left(NetworkFailure('Sem internet e sem cache válido'));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado'));
    }
  }
}
