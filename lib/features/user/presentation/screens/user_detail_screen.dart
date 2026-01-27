import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
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

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                color: Colors.white,
                onPressed: isLoading ? null : _toggleSave,
                tooltip: isSaved ? 'Remover dos salvos' : 'Salvar usuário',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: CachedNetworkImage(
                      imageUrl: widget.user.picture,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(color: Colors.black.withValues(alpha: 0.4)),
                  Center(
                    child: Hero(
                      tag: widget.user.picture,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.user.picture,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      icon: Icons.person,
                      label: 'Gênero',
                      value: widget.user.gender,
                    ),
                    InfoTile(
                      icon: Icons.cake,
                      label: 'Idade',
                      value: '${widget.user.age} anos',
                    ),
                    InfoTile(
                      icon: Icons.calendar_today,
                      label: 'Nascimento',
                      value: _formatDate(widget.user.dob),
                    ),
                    InfoTile(
                      icon: Icons.flag,
                      label: 'Nacionalidade',
                      value: widget.user.nationality,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Section(
                  title: 'Contato',
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
                      icon: Icons.smartphone,
                      label: 'Celular',
                      value: widget.user.cell,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Section(
                  title: 'Endereço',
                  children: [
                    InfoTile(
                      icon: Icons.location_on,
                      label: 'Rua',
                      value: widget.user.street,
                    ),
                    InfoTile(
                      icon: Icons.location_city,
                      label: 'Cidade',
                      value: widget.user.city,
                    ),
                    InfoTile(
                      icon: Icons.map,
                      label: 'Estado',
                      value: widget.user.state,
                    ),
                    InfoTile(
                      icon: Icons.public,
                      label: 'País',
                      value: widget.user.country,
                    ),
                    InfoTile(
                      icon: Icons.markunread_mailbox,
                      label: 'CEP',
                      value: widget.user.postcode,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Section(
                  title: 'Registro',
                  children: [
                    InfoTile(
                      icon: Icons.app_registration,
                      label: 'Data de Registro',
                      value: _formatDate(widget.user.registered),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
