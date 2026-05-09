import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/repositories/session_repository.dart';
import '../../../models/plant_record.dart';
import '../../../models/plant_category.dart';
import '../../../l10n/app_localizations.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final plantRepo = ref.watch(plantRepositoryProvider);
    final sessionRepo = ref.watch(sessionRepositoryProvider);

    return ListView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 64, // safe area + glass app bar
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 80, // safe area + bottom nav
      ),
      children: [
        // Overview Cards
        FutureBuilder<Map<String, int>>(
          future: _getOverviewStats(plantRepo, sessionRepo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final stats = snapshot.data ?? {};

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: l10n.totalPlants,
                        value: '${stats['totalPlants'] ?? 0}',
                        icon: Icons.eco,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: l10n.sessions,
                        value: '${stats['totalSessions'] ?? 0}',
                        icon: Icons.folder,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: l10n.drafts,
                        value: '${stats['draftPlants'] ?? 0}',
                        icon: Icons.edit_note,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: l10n.thisMonth,
                        value: '${stats['thisMonth'] ?? 0}',
                        icon: Icons.calendar_today,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // Plants by Category Chart
        Text(
          l10n.plantsByCategory,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        FutureBuilder<Map<PlantCategory, int>>(
          future: _getCategoryStats(plantRepo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final stats = snapshot.data ?? {};

            if (stats.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noPlantsYet,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(context, stats),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: stats.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(entry.key),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getCategoryName(context, entry.key),
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // Monthly Activity Chart
        Text(
          l10n.collectionsByMonth,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        FutureBuilder<Map<int, int>>(
          future: _getMonthlyStats(plantRepo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final stats = snapshot.data ?? {};

            if (stats.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    l10n.noActivityRecorded,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (stats.values.reduce((a, b) => a > b ? a : b) + 5)
                          .toDouble(),
                      barGroups: _buildBarChartGroups(stats),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final locale = Localizations.localeOf(
                                context,
                              ).languageCode;
                              if (value.toInt() >= 1 && value.toInt() <= 12) {
                                final date = DateTime(2024, value.toInt());
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    DateFormat.MMM(locale).format(date),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Recent Activity
        Text(
          l10n.recentActivity,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<PlantRecord>>(
          future: plantRepo.getPaginated(limit: 5),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final plants = snapshot.data ?? [];

            if (plants.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    l10n.noRecentActivity,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return Card(
              child: Column(
                children: plants.map((plant) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(plant.category),
                      child: Icon(
                        Icons.eco,
                        color: _getCategoryColor(plant.category).computeLuminance() > 0.4
                            ? Colors.black87
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      plant.scientificName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${plant.dateCollected.day}/${plant.dateCollected.month}/${plant.dateCollected.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: plant.isDraft
                        ? Chip(
                            label: Text(
                              l10n.draft,
                              style: TextStyle(fontSize: 10),
                            ),
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<Map<String, int>> _getOverviewStats(
    PlantRepository plantRepo,
    SessionRepository sessionRepo,
  ) async {
    final totalPlants = await plantRepo.count();
    final draftPlants = await plantRepo.count(isDraft: true);
    final totalSessions = await sessionRepo.count(isArchived: false);

    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final thisMonthPlants = await plantRepo.searchByDateRange(
      start: firstDayOfMonth,
      end: now,
      limit: 100000,
    );

    return {
      'totalPlants': totalPlants,
      'draftPlants': draftPlants,
      'totalSessions': totalSessions,
      'thisMonth': thisMonthPlants.length,
    };
  }

  Future<Map<PlantCategory, int>> _getCategoryStats(
    PlantRepository plantRepo,
  ) async {
    final plants = await plantRepo.getPaginated(limit: 10000);
    final Map<PlantCategory, int> stats = {};

    for (final plant in plants) {
      stats[plant.category] = (stats[plant.category] ?? 0) + 1;
    }

    return stats;
  }

  Future<Map<int, int>> _getMonthlyStats(PlantRepository plantRepo) async {
    final plants = await plantRepo.getPaginated(limit: 10000);
    final Map<int, int> stats = {};

    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 6, 1);

    for (final plant in plants) {
      if (plant.dateCollected.isAfter(sixMonthsAgo)) {
        final month = plant.dateCollected.month;
        stats[month] = (stats[month] ?? 0) + 1;
      }
    }

    return stats;
  }

  List<PieChartSectionData> _buildPieChartSections(
    BuildContext context,
    Map<PlantCategory, int> stats,
  ) {
    final total = stats.values.reduce((a, b) => a + b);

    return stats.entries.map((entry) {
      final percentage = (entry.value / total * 100).toStringAsFixed(1);
      final sectionColor = _getCategoryColor(entry.key);
      return PieChartSectionData(
        color: sectionColor,
        value: entry.value.toDouble(),
        title: '$percentage%',
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: sectionColor.computeLuminance() > 0.4 ? Colors.black87 : Colors.white,
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _buildBarChartGroups(Map<int, int> stats) {
    return stats.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.green,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  Color _getCategoryColor(PlantCategory category) {
    switch (category) {
      case PlantCategory.trees:
        return Colors.brown;
      case PlantCategory.shrubs:
        return Colors.green;
      case PlantCategory.herbs:
        return Colors.lightGreen;
      case PlantCategory.ferns:
        return Colors.teal;
      case PlantCategory.grasses:
        return Colors.lime;
      case PlantCategory.vines:
        return Colors.deepOrange;
      case PlantCategory.cacti:
        return Colors.amber;
      case PlantCategory.aquatic:
        return Colors.blue;
    }
  }

  String _getCategoryName(BuildContext context, PlantCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case PlantCategory.trees:
        return l10n.categoryTrees;
      case PlantCategory.shrubs:
        return l10n.categoryShrubs;
      case PlantCategory.herbs:
        return l10n.categoryHerbs;
      case PlantCategory.ferns:
        return l10n.categoryFerns;
      case PlantCategory.grasses:
        return l10n.categoryGrasses;
      case PlantCategory.vines:
        return l10n.categoryVines;
      case PlantCategory.cacti:
        return l10n.categoryCacti;
      case PlantCategory.aquatic:
        return l10n.categoryAquatic;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
