import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<List<UserModel>> fetchUsers();
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.get('https://randomuser.me/api/');

    final results = response.data['results'] as List;

    return results.map((json) => UserModel.fromJson(json)).toList();
  }
}
