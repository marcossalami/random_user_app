import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;

  UserProvider(this.repository);

  final List<UserModel> _users = [];
  List<UserModel> get users => List.unmodifiable(_users);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Timer? _ticker;
  bool _fetching = false;
  Future<void> fetchUser() async {
    if (_fetching) return;

    _fetching = true;
    _isLoading = _users.isEmpty;
    _error = null;
    notifyListeners();

    try {
      final newUsers = await repository.getUsers();
      _users.addAll(newUsers);
    } catch (e) {
      _error = 'Erro ao buscar usuários';
    }

    _isLoading = false;
    _fetching = false;
    notifyListeners();
  }

  void startTicker() {
    _ticker ??= Timer.periodic(const Duration(seconds: 5), (_) => fetchUser());
  }

  void stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void clear() {
    _users.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    stopTicker();
    super.dispose();
  }
}
