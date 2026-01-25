import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:random_user_app/features/user/data/models/user_model.dart';
import 'package:random_user_app/features/user/presentation/widgets/info_tile.dart';
import 'package:random_user_app/features/user/presentation/widgets/section.dart';
import '../../domain/repositories/user_repository.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late UserRepository repository;
  bool isSaved = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    repository = GetIt.I<UserRepository>();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final user = await repository.getById(widget.user.id);
    setState(() => isSaved = user != null);
  }

  Future<void> _toggleSave() async {
    setState(() => isLoading = true);

    if (isSaved) {
      await repository.remove(widget.user.id);
      _showMessage('Usuário removido dos salvos');
    } else {
      await repository.save(widget.user);
      _showMessage('Usuário salvo com sucesso');
    }

    setState(() {
      isSaved = !isSaved;
      isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
                onPressed: isLoading ? null : _toggleSave,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.user.name,
                style: const TextStyle(fontSize: 16),
              ),
              background: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(widget.user.picture),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Section(
                  title: 'Informações Pessoais',
                  children: [
                    InfoTile(
                      icon: Icons.email,
                      label: 'Email',
                      value: widget.user.email,
                    ),
                    InfoTile(
                      icon: Icons.phone,
                      label: 'Telefone',
                      value: widget.user.phone,
                    ),
                    InfoTile(
                      icon: Icons.flag,
                      label: 'Nacionalidade',
                      value: widget.user.nationality,
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading ? null : _toggleSave,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(isSaved ? Icons.delete : Icons.bookmark),
        label: Text(isSaved ? 'Remover' : 'Salvar'),
      ),
    );
  }
}
