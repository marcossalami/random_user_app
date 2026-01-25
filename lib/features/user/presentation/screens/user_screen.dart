import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_user_app/features/user/presentation/provider/user_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserProvider>().clear(),
          ),
        ],
      ),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UserProvider>().fetchUser(),
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildBody(UserProvider vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    if (vm.users.isEmpty) {
      return const Center(child: Text('Nenhum usuário carregado'));
    }

    return ListView.builder(
      itemCount: vm.users.length,
      itemBuilder: (_, index) {
        final user = vm.users[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.picture)),
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
