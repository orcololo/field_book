import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/session_repository.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../models/collection_session.dart';
import '../../../models/plant_record.dart';
import '../../../l10n/app_localizations.dart';
import 'session_form_screen.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  final CollectionSession session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  late CollectionSession _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  Future<void> _refreshSession() async {
    final sessionRepo = ref.read(sessionRepositoryProvider);
    final updated = await sessionRepo.getById(_session.id);
    if (updated != null && mounted) {
      setState(() {
        _session = updated;
      });
    }
  }

  Future<void> _editSession() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionFormScreen(session: _session),
      ),
    );

    if (result == true) {
      await _refreshSession();
    }
  }

  Future<void> _deleteSession() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Sessão'),
        content: Text(l10n.confirmDeleteSession),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final sessionRepo = ref.read(sessionRepositoryProvider);
        await sessionRepo.delete(_session.id);

        if (mounted) {
          Navigator.of(context).pop(true); // Return to list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _toggleArchive() async {
    final sessionRepo = ref.read(sessionRepositoryProvider);

    if (_session.isArchived) {
      await sessionRepo.unarchive(_session.id);
    } else {
      await sessionRepo.archive(_session.id);
    }

    await _refreshSession();
  }

  Future<void> _generateShareCode() async {
    final sessionRepo = ref.read(sessionRepositoryProvider);

    if (_session.shareCode == null) {
      final code = await sessionRepo.generateShareCode();
      _session.shareCode = code;
      await sessionRepo.save(_session);
      await _refreshSession();
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Código de Compartilhamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Compartilhe este código com outros usuários:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _session.shareCode!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantRepo = ref.watch(plantRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_session.tripName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editSession),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _generateShareCode();
                  break;
                case 'archive':
                  _toggleArchive();
                  break;
                case 'delete':
                  _deleteSession();
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Compartilhar'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(_session.isArchived ? Icons.unarchive : Icons.archive),
                    const SizedBox(width: 8),
                    Text(_session.isArchived ? 'Desarquivar' : 'Arquivar'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Excluir', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Session Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dates
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Período',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Início: ${_session.startDate.day}/${_session.startDate.month}/${_session.startDate.year}',
                  ),
                  if (_session.endDate != null)
                    Text(
                      'Término: ${_session.endDate!.day}/${_session.endDate!.month}/${_session.endDate!.year}',
                    ),

                  // Location
                  if (_session.location != null) ...[
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _session.location!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Status badges
                  const Divider(height: 24),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (_session.isArchived)
                        Chip(
                          label: const Text('Arquivado'),
                          avatar: const Icon(Icons.archive, size: 16),
                          backgroundColor: Colors.grey.shade300,
                        ),
                      if (_session.shareCode != null)
                        Chip(
                          label: const Text('Compartilhado'),
                          avatar: const Icon(Icons.share, size: 16),
                          backgroundColor: Colors.blue.shade100,
                        ),
                      if (_session.sharedWith.isNotEmpty)
                        Chip(
                          label: Text(
                            '${_session.sharedWith.length} colaboradores',
                          ),
                          avatar: const Icon(Icons.people, size: 16),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Team Members
          if (_session.teamMembers.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Equipe (${_session.teamMembers.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._session.teamMembers.map((member) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              child: Icon(Icons.person, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(member),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Notes
          if (_session.notes != null && _session.notes!.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notes, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Notas',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_session.notes!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Plants in this session
          Text(
            'Plantas Coletadas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<PlantRecord>>(
            future: plantRepo.getBySession(_session.uuid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final plants = snapshot.data ?? [];

              if (plants.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma planta coletada nesta sessão',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: plants.map((plant) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.eco,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        plant.scientificName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: plant.commonName.isNotEmpty
                          ? Text(plant.commonName)
                          : null,
                      trailing: Text(
                        '${plant.dateCollected.day}/${plant.dateCollected.month}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PlantDetailScreen(plant: plant),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
