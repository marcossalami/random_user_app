import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/dio_config.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Dio
  getIt.registerLazySingleton(() => DioConfig.createDio());

  // ApiClient
  getIt.registerLazySingleton(() => ApiClient(getIt()));
}
