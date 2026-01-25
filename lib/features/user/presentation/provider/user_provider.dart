import 'package:flutter/foundation.dart';

import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;

  UserProvider(this.repository);

  final List<UserModel> _users = [];
  List<UserModel> get users => List.unmodifiable(_users);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newUsers = await repository.getUsers();
      _users.addAll(newUsers);
    } catch (e) {
      _error = 'Erro ao buscar usuários';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _users.clear();
    notifyListeners();
  }
}
