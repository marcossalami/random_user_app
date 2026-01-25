import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:random_user_app/features/user/data/dtos/user_remote_dto.dart';
import 'package:random_user_app/features/user/domain/repositories/user_repository_impl.dart';
import 'package:random_user_app/features/user/presentation/provider/user_provider.dart';

import '../../features/user/domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // HTTP
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://randomuser.me/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  // Datasource
  getIt.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserRemoteDatasource>()),
  );
  getIt.registerFactory<UserProvider>(() => UserProvider(getIt()));
}
