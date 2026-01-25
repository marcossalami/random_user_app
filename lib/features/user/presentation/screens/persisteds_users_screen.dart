import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:random_user_app/features/user/data/models/user_model.dart';
import 'package:random_user_app/features/user/presentation/widgets/empty_state.dart';
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
    final loadedUsers = await repository.getAll();
    setState(() {
      users = loadedUsers;
      isLoading = false;
    });
  }

  Future<void> _deleteUser(UserModel user) async {
    await repository.remove(user.id);
    await _load();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário removido')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários Salvos'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? EmptyState()
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final user = users[index];

                  return Dismissible(
                    key: ValueKey(user.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 24),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _deleteUser(user),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(user.picture),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(user.email),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
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
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
