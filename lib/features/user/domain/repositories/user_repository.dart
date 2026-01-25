import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();

  Future<void> saveUser(UserModel user);
  Future<void> removeUser(String id);
  List<UserModel> getSavedUsers();
  bool isSaved(String id);
}
