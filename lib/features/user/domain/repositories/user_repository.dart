import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getAll();

  Future<void> saveUser(UserModel user);
  Future<void> save(UserModel user);

  Future<void> removeUser(String id);
  Future<void> remove(String id);

  List<UserModel> getSavedUsers();

  bool isSaved(String id);
  Future<UserModel?> getById(String id);

  Future<bool> exists(String id);
}
