import 'package:random_user_app/features/user/data/dtos/user_remote_dto.dart';

import '../../data/models/user_model.dart';
import 'user_repository.dart';
import '../../data/local/user_hive_dto.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remote;
  final UserLocalDatasource local;

  UserRepositoryImpl(this.remote, this.local);

  @override
  Future<List<UserModel>> getUsers() {
    return remote.fetchUsers();
  }

  @override
  Future<List<UserModel>> getAll() {
    return Future.value(local.getAll());
  }

  @override
  Future<void> saveUser(UserModel user) {
    return local.save(user);
  }

  @override
  Future<void> save(UserModel user) {
    return local.save(user);
  }

  @override
  Future<void> removeUser(String id) {
    return local.remove(id);
  }

  @override
  Future<void> remove(String id) {
    return local.remove(id);
  }

  @override
  List<UserModel> getSavedUsers() {
    return local.getAll();
  }

  @override
  bool isSaved(String id) {
    return local.exists(id);
  }

  @override
  Future<UserModel?> getById(String id) async {
    try {
      final users = local.getAll();
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> exists(String id) async {
    return local.exists(id);
  }
}
