import 'package:dio/dio.dart';
import 'package:random_user_app/features/user/data/dtos/user_remote_dto.dart';
import 'package:random_user_app/features/user/data/models/user_parser.dart';

import '../models/user_model.dart';

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.get('https://randomuser.me/api/?results=1');

    if (response.statusCode == 200) {
      return parseUsersInBackground(response.data.toString());
    } else {
      throw Exception('Erro ao buscar usuários');
    }
  }
}
