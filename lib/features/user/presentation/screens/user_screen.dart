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

class _UserScreenState extends State<UserScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late UserProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<UserProvider>();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchUser();
      provider.startTicker(this);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      provider.stopTicker();
    }

    if (state == AppLifecycleState.resumed) {
      provider.startTicker(this);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    provider.stopTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Users'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Usuários salvos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersistedUsersScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: provider.users.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => provider.fetchUser(),
              tooltip: 'Carregar novo usuário',
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  Widget _buildBody() {
    final provider = context.watch<UserProvider>();

    if (provider.isLoading && provider.users.isEmpty) {
      return _buildLoading();
    }

    if (provider.error != null) {
      return _buildError(provider);
    }

    if (provider.users.isEmpty) {
      return _buildEmpty();
    }

    return _buildUserList(provider);
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando usuários...'),
        ],
      ),
    );
  }

  Widget _buildError(UserProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(provider.error!),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => provider.fetchUser(),
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('Nenhum usuário encontrado'),
        ],
      ),
    );
  }

  Widget _buildUserList(UserProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchUser(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: provider.users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final user = provider.users[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user.picture),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailScreen(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
