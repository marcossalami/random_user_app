import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:random_user_app/features/user/presentation/provider/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();

    final provider = context.read<UserProvider>();

    _ticker = createTicker((elapsed) {
      if (elapsed - _lastTick >= const Duration(seconds: 5)) {
        _lastTick = elapsed;
        provider.fetchUser();
      }
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Random Users')),
      body: ListView.builder(
        itemCount: provider.users.length,
        itemBuilder: (_, index) {
          final user = provider.users[index];
          return ListTile(title: Text(user.name), subtitle: Text(user.email));
        },
      ),
    );
  }
}
