import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/repositories/session_repository.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../models/plant_record.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_plant_card.dart';
import '../../../shared/widgets/modern/empty_state_widget.dart';
import '../../../shared/widgets/modern/shimmer_loading.dart';
import '../../../shared/widgets/modern/glass_app_bar.dart';
import '../../../shared/widgets/rain_mode_guard.dart';
import '../../../shared/widgets/modern/sync_status_icon.dart';
import '../../../core/providers/sync_provider.dart';
import '../../../core/providers/rain_mode_provider.dart';
import '../../plant_form/screens/plant_form_screen.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../sessions/screens/session_form_screen.dart';
import '../../sessions/screens/session_detail_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../export_import/screens/export_import_screen.dart';
import '../../map/screens/map_view_screen.dart';
import '../../quick_capture/screens/quick_capture_screen.dart';
import '../../sync/screens/conflict_resolution_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSelectMode = false;
  final Set<int> _selectedIds = {};

  void _exitSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final syncState = ref.watch(syncNotifierProvider);
    final conflictRecordsAsync = ref.watch(conflictRecordsProvider);
    final hasConflictBanner = conflictRecordsAsync.valueOrNull?.isNotEmpty ?? false;
    final rainModeEnabled = ref.watch(rainModeEnabledProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBarFrosted(
        leading: _isSelectMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectMode,
              )
            : null,
        title: _isSelectMode ? l10n.nSelected(_selectedIds.length) : null,
        actions: [
          if (!_isSelectMode && rainModeEnabled)
            Padding(
              padding: const EdgeInsets.only(right: FoliumTheme.space8),
              child: Tooltip(
                message: l10n.rainModeBadge,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FoliumTheme.space10,
                    vertical: FoliumTheme.space8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
                    border: Border.all(
                      color: colorScheme.tertiary.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Text(
                    '🌧️',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          if (_selectedIndex == 0 && !_isSelectMode) ...[
            IconButton(
              tooltip: syncState.isSyncing 
                ? l10n.syncing 
                : syncState.lastError != null 
                  ? l10n.syncErrorTitle 
                  : l10n.syncNow,
              icon: const SyncStatusIcon(),
              onPressed: syncState.isSyncing 
                ? null 
                : () => ref.read(syncNotifierProvider.notifier).sync(),
            ),
            IconButton(
              tooltip: l10n.selectMode,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(
                  Icons.checklist,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              onPressed: () {
                setState(() {
                  _isSelectMode = true;
                });
              },
            ),
            IconButton(
              tooltip: l10n.searchTooltip,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(Icons.search, color: colorScheme.primary, size: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ],
          if (_isSelectMode) ...[
            IconButton(
              tooltip: l10n.selectAll,
              icon: const Icon(Icons.select_all),
              onPressed: () => setState(() {
                _selectAllPlants();
              }),
            ),
            IconButton(
              tooltip: l10n.deleteSelected,
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: _selectedIds.isEmpty
                  ? null
                  : () => _bulkDelete(l10n),
            ),
            IconButton(
              tooltip: l10n.exportSelected,
              icon: const Icon(Icons.ios_share),
              onPressed: _selectedIds.isEmpty
                  ? null
                  : () => _bulkExport(context),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_selectedIndex == 0)
            conflictRecordsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (conflicts) {
                if (conflicts.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    FoliumTheme.space16,
                    MediaQuery.of(context).padding.top + 64,
                    FoliumTheme.space16,
                    0,
                  ),
                  child: MaterialBanner(
                    backgroundColor: colorScheme.errorContainer,
                    content: Text(
                      l10n.syncConflictBannerMessage(conflicts.length),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                    leading: Icon(
                      Icons.sync_problem_outlined,
                      color: colorScheme.onErrorContainer,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ConflictResolutionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.resolveConflicts,
                          style: TextStyle(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _PlantsTab(
                  key: ValueKey('$_selectedIndex-$_isSelectMode'),
                  hasConflictBanner: hasConflictBanner,
                  isSelectMode: _isSelectMode,
                  selectedIds: _selectedIds,
                  onToggleSelect: (id) {
                    setState(() {
                      if (_selectedIds.contains(id)) {
                        _selectedIds.remove(id);
                      } else {
                        _selectedIds.add(id);
                      }
                    });
                  },
                  onPlantsLoaded: (ids) {
                    _allPlantIds = ids;
                  },
                ),
                const _SessionsTab(),
                const MapViewScreen(),
                const StatisticsScreen(),
                const SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: colorScheme.surface,
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.eco_outlined),
            selectedIcon: const Icon(Icons.eco),
            label: l10n.plants,
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder),
            label: l10n.sessions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.map,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.statistics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
      floatingActionButton: _isSelectMode
          ? null
          : _selectedIndex == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: 'rain_mode_toggle_fab',
                  tooltip: rainModeEnabled
                      ? l10n.disableRainModeQuickAction
                      : l10n.enableRainModeQuickAction,
                  onPressed: () async {
                    await ref.read(rainModeNotifierProvider.notifier).toggle();
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          rainModeEnabled
                              ? l10n.rainModeDisabledMessage
                              : l10n.rainModeEnabledMessage,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '🌧️',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: FoliumTheme.space12),
                FloatingActionButton.extended(
                  heroTag: 'new_plant_fab',
                  onPressed: () => _showNewPlantOptions(context, l10n),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newPlant),
                ),
              ],
            )
          : _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SessionFormScreen(),
                  ),
                );
                if (!mounted) return;
                if (result == true) {
                  setState(() {}); // Refresh the list
                }
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.newSession),
            )
          : null,
    );
  }

  List<int> _allPlantIds = [];

  void _selectAllPlants() {
    if (_selectedIds.length == _allPlantIds.length) {
      _selectedIds.clear();
    } else {
      _selectedIds.addAll(_allPlantIds);
    }
  }

  Future<void> _bulkDelete(AppLocalizations l10n) async {
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    final initialConfirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteSelected),
        content: Text(l10n.confirmDeleteCount(_selectedIds.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (initialConfirmed != true) return;
    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.deleteSelected,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeDeleteConfirmTitle,
      confirmMessage: l10n.confirmDeleteCount(_selectedIds.length),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: errorColor,
    );
    if (!mounted) return;
    if (confirmed != true) return;
    final plantRepo = ref.read(plantRepositoryProvider);
    await plantRepo.bulkDelete(_selectedIds.toList());
    if (!mounted) return;
    final count = _selectedIds.length;
    messenger.showSnackBar(SnackBar(content: Text(l10n.nPlantsDeleted(count))));
    _exitSelectMode();
  }

  Future<void> _bulkExport(BuildContext context) async {
    final navigator = Navigator.of(context);
    final plantRepo = ref.read(plantRepositoryProvider);
    final plants = await plantRepo.getByIds(_selectedIds.toList());
    if (!mounted || plants.isEmpty) return;
    _exitSelectMode();
    navigator.push(
      MaterialPageRoute(
        builder: (_) => ExportImportScreen(preSelectedPlants: plants),
      ),
    );
  }

  void _showNewPlantOptions(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FoliumTheme.radiusMedium),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: FoliumTheme.space16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      FoliumTheme.radiusSmall,
                    ),
                  ),
                  child: Icon(Icons.eco, color: colorScheme.primary),
                ),
                title: Text(l10n.newPlant),
                subtitle: Text(l10n.newPlantSubtitle),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PlantFormScreen()),
                  );
                  if (!mounted) return;
                  if (result == true) setState(() {});
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(
                      FoliumTheme.radiusSmall,
                    ),
                  ),
                  child: Icon(Icons.flash_on, color: colorScheme.tertiary),
                ),
                title: Text(l10n.quickCapture),
                subtitle: Text(l10n.quickCaptureSubtitle),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuickCaptureScreen(),
                    ),
                  );
                  if (!mounted) return;
                  if (result == true) setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlantsTab extends ConsumerStatefulWidget {
  final bool hasConflictBanner;
  final bool isSelectMode;
  final Set<int> selectedIds;
  final ValueChanged<int>? onToggleSelect;
  final ValueChanged<List<int>>? onPlantsLoaded;

  const _PlantsTab({
    super.key,
    this.hasConflictBanner = false,
    this.isSelectMode = false,
    this.selectedIds = const {},
    this.onToggleSelect,
    this.onPlantsLoaded,
  });

  @override
  ConsumerState<_PlantsTab> createState() => _PlantsTabState();
}

class _PlantsTabState extends ConsumerState<_PlantsTab> {
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plantRepo = ref.watch(plantRepositoryProvider);

    return FutureBuilder<List<PlantRecord>>(
      key: ValueKey(_refreshKey),
      future: plantRepo.getPaginated(limit: 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 3,
            padding: EdgeInsets.only(
              top: widget.hasConflictBanner ? 16 : MediaQuery.of(context).padding.top + 64,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            itemBuilder: (context, index) {
              return ShimmerLoading(child: ShimmerPlaceholders.plantCard(context: context));
            },
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.only(top: widget.hasConflictBanner ? 16 : MediaQuery.of(context).padding.top + 64),
            child: EmptyStates.error(
              context: context,
              message: '${l10n.errorOccurred}: ${snapshot.error}',
              onRetry: _refresh,
            ),
          );
        }

        final plants = snapshot.data ?? [];

        if (plants.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onPlantsLoaded?.call(plants.map((p) => p.id).toList());
          });
        }

        if (plants.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: widget.hasConflictBanner ? 16 : MediaQuery.of(context).padding.top + 64),
            child: EmptyStates.noPlants(context: context),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _refresh();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: plants.length,
            padding: EdgeInsets.only(
              top: widget.hasConflictBanner ? 16 : MediaQuery.of(context).padding.top + 64,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            itemBuilder: (context, index) {
              final plant = plants[index];
              final isSelected =
                  widget.isSelectMode && widget.selectedIds.contains(plant.id);
              return Stack(
                children: [
                  ModernPlantCard(
                    plant: plant,
                    onTap: () async {
                      if (widget.isSelectMode) {
                        widget.onToggleSelect?.call(plant.id);
                        return;
                      }
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlantDetailScreen(plant: plant),
                        ),
                      );
                      if (result == true && mounted) {
                        _refresh();
                      }
                    },
                  ),
                  if (widget.isSelectMode)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => widget.onToggleSelect?.call(plant.id),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SessionsTab extends ConsumerStatefulWidget {
  const _SessionsTab();

  @override
  ConsumerState<_SessionsTab> createState() => _SessionsTabState();
}

class _SessionsTabState extends ConsumerState<_SessionsTab> {
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sessionRepo = ref.watch(sessionRepositoryProvider);

    return FutureBuilder(
      key: ValueKey(_refreshKey),
      future: sessionRepo.getAll(isArchived: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 3,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 64,
              left: FoliumTheme.space16,
              right: FoliumTheme.space16,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            itemBuilder: (context, index) {
              return ShimmerLoading(child: ShimmerPlaceholders.listItem(context: context));
            },
          );
        }

        final sessions = snapshot.data ?? [];

        if (sessions.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 64),
            child: EmptyStates.noSessions(context: context),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _refresh();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: sessions.length,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 64,
              left: FoliumTheme.space16,
              right: FoliumTheme.space16,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: FoliumTheme.space12),
                decoration: FoliumTheme.cardDecoration(),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionDetailScreen(session: session),
                      ),
                    );
                    if (result == true && mounted) {
                      _refresh();
                    }
                  },
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusMedium),
                  child: Padding(
                    padding: const EdgeInsets.all(FoliumTheme.space16),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(
                              FoliumTheme.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            Icons.folder,
                            color: colorScheme.tertiary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: FoliumTheme.space16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.tripName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: FoliumTheme.space4),
                              Text(
                                '${session.startDate.day}/${session.startDate.month}/${session.startDate.year}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              if (session.location != null) ...[
                                const SizedBox(height: FoliumTheme.space4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: FoliumTheme.space4),
                                    Expanded(
                                      child: Text(
                                        session.location!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (session.teamMembers.isNotEmpty ||
                                  session.sharedWith.isNotEmpty) ...[
                                const SizedBox(height: FoliumTheme.space8),
                                Wrap(
                                  spacing: FoliumTheme.space8,
                                  children: [
                                    if (session.teamMembers.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: FoliumTheme.space8,
                                          vertical: FoliumTheme.space4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            FoliumTheme.radiusFull,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.people,
                                              size: 12,
                                              color: colorScheme.primary,
                                            ),
                                            const SizedBox(
                                              width: FoliumTheme.space4,
                                            ),
                                            Text(
                                              '${session.teamMembers.length}',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: colorScheme.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (session.sharedWith.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: FoliumTheme.space8,
                                          vertical: FoliumTheme.space4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.tertiaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            FoliumTheme.radiusFull,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.share,
                                              size: 12,
                                              color: colorScheme.tertiary,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Arrow
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
