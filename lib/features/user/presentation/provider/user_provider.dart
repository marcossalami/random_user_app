import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:random_user_app/features/user/data/models/user_model.dart';
import 'package:random_user_app/features/user/domain/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;

  UserProvider(this.repository);

  final List<UserModel> _users = [];
  List<UserModel> get users => List.unmodifiable(_users);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Ticker? _ticker;
  Duration _lastTick = Duration.zero;
  bool _fetching = false;

  void startTicker(TickerProvider vsync) {
    if (_ticker != null) return;

    _ticker = vsync.createTicker((elapsed) {
      if (elapsed.inSeconds - _lastTick.inSeconds >= 5) {
        _lastTick = elapsed;
        fetchUser();
      }
    });

    _ticker!.start();
  }

  void stopTicker() {
    _ticker?.dispose();
    _ticker = null;
    _lastTick = Duration.zero;
  }

  Future<void> fetchUser() async {
    if (_fetching) return;

    _fetching = true;
    _isLoading = _users.isEmpty;
    _error = null;
    notifyListeners();

    try {
      final newUsers = await repository.getUsers();

      for (final user in newUsers) {
        _users.add(user);
      }
    } catch (_) {
      _error = 'Erro ao buscar usuários';
    }

    _isLoading = false;
    _fetching = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTicker();
    super.dispose();
  }
}
