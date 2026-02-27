import 'package:crypto_tracker/features/data/datasource/crypto_datasource.dart';
import 'package:crypto_tracker/features/domain/entity/crypto.dart';
import 'package:crypto_tracker/features/domain/repository/crypto_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource dataSource;

  CryptoRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Crypto>>> getCoins(int page) async {
    try {
      final model = await dataSource(page);
      return Right(model);
    } catch (e) {
      if (e.toString().contains("Not Found")) {
        return Left(NotFoundFailure("Moedas não encontradas"));
      }

      return Left(ServerFailure("Erro inesperado"));
    }
  }
}
