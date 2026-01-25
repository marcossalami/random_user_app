import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:random_user_app/features/user/data/models/user_model.dart';
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
    try {
      final user = await repository.getById(widget.user.id);
      setState(() => isSaved = user != null);
    } catch (e) {
      setState(() => isSaved = false);
    }
  }

  Future<void> _toggleSave() async {
    setState(() => isLoading = true);
    try {
      if (isSaved) {
        await repository.remove(widget.user.id);
        _showMessage('Usuário removido dos salvos');
      } else {
        await repository.save(widget.user);
        _showMessage('Usuário salvo com sucesso');
      }
      setState(() => isSaved = !isSaved);
    } catch (e) {
      _showMessage('Erro ao salvar/remover usuário');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Usuário'),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
            onPressed: isLoading ? null : _toggleSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.user.picture),
            ),
            const SizedBox(height: 24),
            _buildDetailCard('Nome', widget.user.name),
            _buildDetailCard('Email', widget.user.email),
            _buildDetailCard('Telefone', widget.user.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value),
          ],
        ),
      ),
    );
  }
}
