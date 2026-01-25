import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_user_app/features/user/presentation/provider/user_provider.dart';
import 'package:random_user_app/features/user/presentation/screens/persisteds_users_screen.dart';
import 'user_detail_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = context.read<UserProvider>();
      provider.fetchUser(); // primeira carga
      provider.startTicker(); // ticker a cada 5s
    });
  }

  @override
  void dispose() {
    /// 🛑 para o ticker ao sair da tela
    context.read<UserProvider>().stopTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Usuários persistidos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersistedUsersScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(UserProvider provider) {
    if (provider.isLoading && provider.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    if (provider.users.isEmpty) {
      return const Center(child: Text('Nenhum usuário encontrado'));
    }

    return ListView.separated(
      itemCount: provider.users.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final user = provider.users[index];

        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.picture)),
          title: Text(user.name),
          subtitle: Text(user.email),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            );
          },
        );
      },
    );
  }
}
