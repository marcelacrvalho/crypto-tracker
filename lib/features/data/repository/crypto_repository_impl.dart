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

  bool _isRevalidating = false;

  CryptoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Crypto>>> getCoins(int page) async {
    try {
      final cachedCoins = await localDatasource.getCachedCoins();

      /// SEM CACHE
      if (cachedCoins.isEmpty) {
        return _fetchFromRemote(page);
      }

      final cacheValid = await localDatasource.isCachedValid();

      /// CACHE OK
      if (cacheValid) {
        return Right(cachedCoins);
      }

      /// SWR
      _revalidateCoins(page);

      return Right(cachedCoins);
    } catch (_) {
      return Left(ServerFailure('Erro inesperado'));
    }
  }

  Future<Either<Failure, List<Crypto>>> _fetchFromRemote(int page) async {
    final isConnected = await networkInfo.isConnected();

    if (!isConnected) {
      return Left(NetworkFailure('Sem internet'));
    }

    final remoteCoins = await remoteDataSource(page);
    await localDatasource.cacheCoins(remoteCoins);

    return Right(remoteCoins);
  }

  Future<void> _revalidateCoins(int page) async {
    if (_isRevalidating) return;

    _isRevalidating = true;

    final isConnected = await networkInfo.isConnected();

    if (!isConnected) {
      _isRevalidating = false;
      return;
    }

    try {
      final remoteCoins = await remoteDataSource(page);
      await localDatasource.cacheCoins(remoteCoins);
    } catch (_) {}

    _isRevalidating = false;
  }
}
