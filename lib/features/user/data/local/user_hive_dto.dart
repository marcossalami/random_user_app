import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class UserLocalDatasource {
  Future<void> save(UserModel user);
  Future<void> remove(String id);
  List<UserModel> getAll();
  bool exists(String id);
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  static const boxName = 'users';

  Box<UserModel> get _box => Hive.box<UserModel>(boxName);

  @override
  Future<void> save(UserModel user) async {
    await _box.put(user.id, user);
  }

  @override
  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  @override
  List<UserModel> getAll() {
    return _box.values.toList();
  }

  @override
  bool exists(String id) {
    return _box.containsKey(id);
  }
}
