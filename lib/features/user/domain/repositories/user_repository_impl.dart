import 'package:random_user_app/features/user/data/dtos/user_remote_dto.dart';

import '../../data/models/user_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<UserModel>> getUsers() {
    return remoteDatasource.fetchUsers();
  }
}
