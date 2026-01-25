import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:random_user_app/features/user/data/dtos/user_remote_dto.dart';
import 'package:random_user_app/features/user/presentation/screens/user_screen.dart';

import 'features/user/domain/repositories/user_repository_impl.dart';
import 'features/user/presentation/provider/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final dio = Dio();
            final datasource = UserRemoteDatasourceImpl(dio);
            final repository = UserRepositoryImpl(datasource);

            return UserProvider(repository);
          },
        ),
      ],
      child: UserScreen(),
    ),
  );
}
