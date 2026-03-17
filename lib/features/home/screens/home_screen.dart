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
import '../../plant_form/screens/plant_form_screen.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../sessions/screens/session_form_screen.dart';
import '../../sessions/screens/session_detail_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../map/screens/map_view_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: FoliumTheme.surface,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBarFrosted(
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FoliumTheme.primaryMain.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.search,
                  color: FoliumTheme.primaryMain,
                  size: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _PlantsTab(key: ValueKey(_selectedIndex)),
          const _SessionsTab(),
          const MapViewScreen(),
          const StatisticsScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: FoliumTheme.surface,
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
            label: 'Mapa',
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PlantFormScreen(),
                  ),
                );
                if (result == true) {
                  setState(() {}); // Refresh the list
                }
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.newPlant),
            )
          : _selectedIndex == 1
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SessionFormScreen(),
                      ),
                    );
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
}

class _PlantsTab extends ConsumerStatefulWidget {
  const _PlantsTab({super.key});

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
            padding: const EdgeInsets.only(
              top: 80, // Account for app bar
              left: 0,
              right: 0,
              bottom: 100, // Account for bottom navigation bar
            ),
            itemBuilder: (context, index) {
              return ShimmerLoading(
                child: ShimmerPlaceholders.plantCard(),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: 80),
            child: EmptyStates.error(
              message: '${l10n.errorOccurred}: ${snapshot.error}',
              onRetry: _refresh,
            ),
          );
        }

        final plants = snapshot.data ?? [];

        if (plants.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 80),
            child: EmptyStates.noPlants(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _refresh();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: plants.length,
            padding: const EdgeInsets.only(
              top: 80, // Account for app bar
              left: 0,
              right: 0,
              bottom: 100, // Account for bottom navigation bar
            ),
            itemBuilder: (context, index) {
              final plant = plants[index];
              return ModernPlantCard(
                plant: plant,
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlantDetailScreen(plant: plant),
                    ),
                  );
                  if (result == true && mounted) {
                    _refresh();
                  }
                },
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
    final sessionRepo = ref.watch(sessionRepositoryProvider);

    return FutureBuilder(
      key: ValueKey(_refreshKey),
      future: sessionRepo.getAll(isArchived: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 3,
            padding: const EdgeInsets.only(
              top: 80,
              left: FoliumTheme.space16,
              right: FoliumTheme.space16,
              bottom: 100, // Account for bottom navigation bar
            ),
            itemBuilder: (context, index) {
              return ShimmerLoading(
                child: ShimmerPlaceholders.listItem(),
              );
            },
          );
        }

        final sessions = snapshot.data ?? [];

        if (sessions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 80),
            child: EmptyStates.noSessions(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _refresh();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            itemCount: sessions.length,
            padding: const EdgeInsets.only(
              top: 80,
              left: FoliumTheme.space16,
              right: FoliumTheme.space16,
              bottom: 100, // Account for bottom navigation bar
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
                        builder: (context) => SessionDetailScreen(session: session),
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
                            color: FoliumTheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.folder,
                            color: FoliumTheme.tertiaryMain,
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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: FoliumTheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: FoliumTheme.space4),
                              Text(
                                '${session.startDate.day}/${session.startDate.month}/${session.startDate.year}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: FoliumTheme.onSurfaceVariant,
                                    ),
                              ),
                              if (session.location != null) ...[
                                const SizedBox(height: FoliumTheme.space4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: FoliumTheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: FoliumTheme.space4),
                                    Expanded(
                                      child: Text(
                                        session.location!,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: FoliumTheme.onSurfaceVariant,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (session.teamMembers.isNotEmpty || session.sharedWith.isNotEmpty) ...[
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
                                          color: FoliumTheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.people,
                                              size: 12,
                                              color: FoliumTheme.primaryMain,
                                            ),
                                            const SizedBox(width: FoliumTheme.space4),
                                            Text(
                                              '${session.teamMembers.length}',
                                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                    color: FoliumTheme.primaryMain,
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
                                          color: FoliumTheme.tertiaryContainer,
                                          borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.share,
                                              size: 12,
                                              color: FoliumTheme.tertiaryMain,
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
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: FoliumTheme.onSurfaceVariant,
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
