import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:random_user_app/features/user/data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_detail_screen.dart';

class PersistedUsersScreen extends StatefulWidget {
  const PersistedUsersScreen({super.key});

  @override
  State<PersistedUsersScreen> createState() => _PersistedUsersScreenState();
}

class _PersistedUsersScreenState extends State<PersistedUsersScreen> {
  late UserRepository repository;
  List<UserModel> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    repository = GetIt.I<UserRepository>();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    try {
      final loadedUsers = await repository.getAll();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      _showError('Erro ao carregar usuários');
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteUser(UserModel user) async {
    try {
      await repository.remove(user.id);
      await _load();
      _showSuccess('Usuário removido com sucesso');
    } catch (e) {
      _showError('Erro ao remover usuário');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários Salvos')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text('Nenhum usuário salvo'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.picture),
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(user),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailScreen(user: user),
                      ),
                    );
                    _load();
                  },
                );
              },
            ),
    );
  }
}
