import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/repositories/session_repository.dart';
import '../../../core/services/gps_track_service.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../models/collection_session.dart';
import '../../../models/plant_record.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/rain_mode_guard.dart';
import '../../../core/providers/rain_mode_provider.dart';
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
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    final initialConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSessionTitle),
        content: Text(l10n.confirmDeleteSession),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteSessionConfirm),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (initialConfirmed != true) return;

    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.deleteSessionTitle,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeDeleteConfirmTitle,
      confirmMessage: l10n.confirmDeleteSession,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.deleteSessionConfirm,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: errorColor,
    );

    if (!mounted) return;
    if (confirmed != true) return;

    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      await sessionRepo.delete(_session.id);
      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: errorColor),
      );
    }
  }

  Future<void> _toggleArchive() async {
    final l10n = AppLocalizations.of(context)!;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final sessionRepo = ref.read(sessionRepositoryProvider);

    if (!_session.isArchived) {
      final initialConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.archive),
          content: Text(l10n.rainModeArchiveConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.archive),
            ),
          ],
        ),
      );

      if (!mounted) return;
      if (initialConfirmed != true) return;

      final confirmed = await RainModeGuard.confirmDestructiveAction(
        context: context,
        rainModeEnabled: ref.read(rainModeEnabledProvider),
        actionLabel: l10n.archive,
        overlayTitle: l10n.rainModeOverlayTitle,
        overlayMessage: l10n.rainModeOverlayMessage,
        unlockHint: l10n.rainModeUnlockHold,
        unlockAlternativeHint: l10n.rainModeUnlockTap,
        confirmTitle: l10n.rainModeArchiveConfirmTitle,
        confirmMessage: l10n.rainModeArchiveConfirmMessage,
        cancelLabel: l10n.cancel,
        confirmLabel: l10n.archive,
        countdownLabel: l10n.rainModeCountdownLabel,
        confirmColor: tertiaryColor,
      );

      if (!mounted) return;
      if (confirmed != true) return;
    }

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
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
          title: Text(l10n.shareCodeTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.shareWithUsersHint),
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
              child: Text(l10n.close),
            ),
          ],
        );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plantRepo = ref.watch(plantRepositoryProvider);
    final gpsTrackState = ref.watch(gpsTrackServiceProvider);
    final isTrackingCurrentSession =
        gpsTrackState.isTracking && gpsTrackState.sessionUuid == _session.uuid;

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
            itemBuilder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 8),
                    Text(l10n.share),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(_session.isArchived ? Icons.unarchive : Icons.archive),
                    const SizedBox(width: 8),
                    Text(_session.isArchived ? l10n.unarchive : l10n.archive),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(l10n.excluir, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ];
            },
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
                          l10n.dateRange,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.sessionStartDateValue(
                      '${_session.startDate.day}/${_session.startDate.month}/${_session.startDate.year}',
                    ),
                  ),
                  if (_session.endDate != null)
                    Text(
                      l10n.sessionEndDateValue(
                        '${_session.endDate!.day}/${_session.endDate!.month}/${_session.endDate!.year}',
                      ),
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

                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(
                        isTrackingCurrentSession ? Icons.route : Icons.route_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.gpsTrackTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _toggleTrack(isTrackingCurrentSession),
                        icon: Icon(
                          isTrackingCurrentSession ? Icons.pause : Icons.play_arrow,
                        ),
                        label: Text(
                          isTrackingCurrentSession
                              ? l10n.pauseTrack
                              : l10n.startTrack,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.pin_drop, size: 16),
                        label: Text(l10n.gpsTrackPoints(_session.track.length)),
                      ),
                      Chip(
                        avatar: Icon(
                          isTrackingCurrentSession ? Icons.gps_fixed : Icons.pause_circle,
                          size: 16,
                        ),
                        label: Text(
                          isTrackingCurrentSession
                              ? l10n.gpsTrackActive
                              : l10n.gpsTrackPaused,
                        ),
                      ),
                    ],
                  ),

                  // Status badges
                  const Divider(height: 24),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (_session.isArchived)
                        Chip(
                          label: Text(l10n.archivedLabel),
                          avatar: const Icon(Icons.archive, size: 16),
                          backgroundColor: Colors.grey.shade300,
                        ),
                      if (_session.shareCode != null)
                        Chip(
                          label: Text(l10n.sharedLabel),
                          avatar: const Icon(Icons.share, size: 16),
                          backgroundColor: Colors.blue.shade100,
                        ),
                      if (_session.sharedWith.isNotEmpty)
                        Chip(
                          label: Text(
                            l10n.sessionCollaborators(_session.sharedWith.length),
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
                          l10n.sessionTeamCount(_session.teamMembers.length),
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
                          l10n.notes,
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
            l10n.sessionCollectedPlantsTitle,
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
                          l10n.noPlantsCollectedInSession,
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

  Future<void> _toggleTrack(bool isTrackingCurrentSession) async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    try {
      final gpsTrackService = ref.read(gpsTrackServiceProvider.notifier);
      if (isTrackingCurrentSession) {
        await gpsTrackService.stopTracking();
      } else {
        await gpsTrackService.startTracking(_session.uuid);
      }

      await _refreshSession();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_mapTrackError(l10n, e.toString())),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }

  String _mapTrackError(AppLocalizations l10n, String error) {
    if (error.contains('location_services_disabled')) {
      return l10n.locationServicesDisabled;
    }
    if (error.contains('location_permission_denied_forever')) {
      return l10n.locationPermissionRequired;
    }
    if (error.contains('location_permission_denied')) {
      return l10n.permissionLocation;
    }
    return l10n.errorOccurred;
  }
}
