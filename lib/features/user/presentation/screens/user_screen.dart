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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => provider.fetchUser(),
        edgeOffset: 100,
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(
                'Random Users',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              pinned: true,
              stretch: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmarks_outlined),
                  style: IconButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                  ),
                  tooltip: 'Usuários salvos',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PersistedUsersScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            _buildSliverBody(provider, colorScheme),
          ],
        ),
      ),
      floatingActionButton: provider.users.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => provider.fetchUser(),
              tooltip: 'Carregar novo usuário',
              icon: const Icon(Icons.refresh),
              label: const Text('Novo'),
            )
          : null,
    );
  }

  Widget _buildSliverBody(UserProvider provider, ColorScheme colorScheme) {
    if (provider.isLoading && provider.users.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando usuários...'),
            ],
          ),
        ),
      );
    }

    if (provider.error != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
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
        ),
      );
    }

    if (provider.users.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('Nenhum usuário encontrado'),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final user = provider.users[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailScreen(user: user),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: user.picture,
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(user.picture),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.public,
                                  size: 14,
                                  color: colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user.nationality,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: colorScheme.secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, childCount: provider.users.length),
      ),
    );
  }
}
