import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:random_user_app/core/di/injector.dart';
import 'package:random_user_app/features/user/data/models/user_model.dart';

import 'package:random_user_app/features/user/presentation/screens/user_screen.dart';

import 'features/user/presentation/provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');

  setupDependencies();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => getIt<UserProvider>())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random User App',
      theme: ThemeData(useMaterial3: true),
      home: const UserScreen(),
    );
  }
}
