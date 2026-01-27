import 'package:cached_network_image/cached_network_image.dart';
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
    setState(() {
      users.remove(user);
    });

    await repository.remove(user.id);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário removido')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        edgeOffset: 100,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Usuários Salvos',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              pinned: true,
            ),
            if (isLoading && users.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (users.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: ValueKey(user.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteUser(user),
                        background: Container(
                          padding: const EdgeInsets.only(right: 24),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.delete_sweep,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          elevation: 0,
                          color: colorScheme.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserDetailScreen(user: user),
                                ),
                              );
                              _load();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: user.picture,
                                    child: CircleAvatar(
                                      radius: 36,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                            user.picture,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildUserInfo(context, user),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.public, size: 14, color: colorScheme.secondary),
            const SizedBox(width: 4),
            Text(
              user.nationality,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
