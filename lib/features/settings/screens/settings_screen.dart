import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../models/settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/shimmer_loading.dart';
import '../../../shared/widgets/rain_mode_guard.dart';
import '../../export_import/screens/export_import_screen.dart';
import '../../onboarding/screens/onboarding_screen.dart';
import '../../../core/services/google_drive_backup_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/rain_mode_provider.dart';
import '../../../core/providers/sync_provider.dart';
import '../../auth/screens/login_screen.dart';
import 'identifier_management_screen.dart';
import 'templates_screen.dart';
import 'inaturalist_auth_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: settingsAsync.when(
        loading: () => ListView.builder(
          itemCount: 5,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 64,
            left: FoliumTheme.space16,
            right: FoliumTheme.space16,
          ),
          itemBuilder: (context, index) {
            return ShimmerLoading(child: ShimmerPlaceholders.listItem(context: context));
          },
        ),
        error: (error, stack) {
          final colorScheme = Theme.of(context).colorScheme;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                const SizedBox(height: FoliumTheme.space16),
                Text(
                  l10n.errorLoadingSettings,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: FoliumTheme.space8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        data: (settings) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                left: FoliumTheme.space16,
                right: FoliumTheme.space16,
                top: MediaQuery.of(context).padding.top + 64,
                bottom: MediaQuery.of(context).padding.bottom + 80,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader(context, l10n.general),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _LanguageTile(settings: settings),
                      const Divider(height: 1),
                      _RainModeTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.accessibilityTitle),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _HighContrastTile(settings: settings),
                      const Divider(height: 1),
                      _FontScaleTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.registryIdentification),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _IdentifierManagementTile(),
                      const Divider(height: 1),
                      _UserInitialsTile(settings: settings),
                      const Divider(height: 1),
                      _LastRegistryNumberTile(settings: settings),
                      const Divider(height: 1),
                      _AutoGenerateIdentifierTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.map),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _MapProviderTile(settings: settings),
                      const Divider(height: 1),
                      _MapCacheTile(settings: settings),
                      const Divider(height: 1),
                      _AutoCacheTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.formSection),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _CollectionTemplatesTile(),
                      const Divider(height: 1),
                      _AutoSaveTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.photos),
                  const SizedBox(height: FoliumTheme.space8),
                   _buildModernCard(
                     context,
                     children: [
                       _PhotoQualityTile(settings: settings),
                       const Divider(height: 1),
                       _PreserveExifTile(settings: settings),
                       const Divider(height: 1),
                       _PlantNetApiKeyTile(settings: settings),
                     ],
                   ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.audioSection),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _TranscriptionTile(settings: settings),
                      const Divider(height: 1),
                      _TranscriptionLocaleTile(settings: settings),
                      const Divider(height: 1),
                      _AudioQualityTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.backupAndData),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(FoliumTheme.space8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(
                              FoliumTheme.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            Icons.import_export,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        title: Text(l10n.exportAndImport),
                        subtitle: Text(l10n.localDataBackup),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExportImportScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(FoliumTheme.space8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              FoliumTheme.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            Icons.outbox_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(l10n.inaturalist),
                        subtitle: Text(
                          settings.inatAccessToken?.trim().isNotEmpty ?? false
                              ? l10n.inaturalistConfigured(
                                  settings.inatUsername?.trim().isNotEmpty ?? false
                                      ? settings.inatUsername!.trim()
                                      : l10n.inaturalist,
                                )
                              : l10n.inaturalistNotConfigured,
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const InaturalistAuthScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _CloudBackupEnabledTile(settings: settings),
                      const Divider(height: 1),
                      _CloudBackupProviderTile(settings: settings),
                      const Divider(height: 1),
                      _CloudBackupWifiOnlyTile(settings: settings),
                      if (settings.cloudBackupEnabled &&
                          settings.cloudBackupProvider ==
                              CloudBackupProvider.googleDrive) ...[
                        const Divider(height: 1),
                        _BackupActionButtons(settings: settings),
                      ],
                      if (settings.lastCloudBackup != null) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(FoliumTheme.space8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(
                                FoliumTheme.radiusSmall,
                              ),
                            ),
                            child: Icon(
                              Icons.access_time,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(l10n.lastBackupLabel),
                          subtitle: Text(
                            _formatDateTime(settings.lastCloudBackup!),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.account),
                  const SizedBox(height: FoliumTheme.space8),
                  _AccountSection(settings: settings),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.syncSection),
                  const SizedBox(height: FoliumTheme.space8),
                  _SyncSection(settings: settings),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.performance),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      _PaginationSizeTile(settings: settings),
                      const Divider(height: 1),
                      _ThumbnailCacheTile(settings: settings),
                    ],
                  ),

                  const SizedBox(height: FoliumTheme.space24),
                  _buildSectionHeader(context, l10n.about),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(FoliumTheme.space8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(
                              FoliumTheme.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            Icons.school_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        title: Text(l10n.showTutorial),
                        subtitle: Text(l10n.showTutorialSubtitle),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onTap: () async {
                          await ref
                              .read(settingsNotifierProvider.notifier)
                              .setHasCompletedOnboarding(false);
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const OnboardingScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(FoliumTheme.space8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              FoliumTheme.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(l10n.aboutApp),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: l10n.appTitle,
                            applicationVersion: '1.8.0',
                            applicationLegalese: '© 2026 Folium',
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'Um aplicativo para registro e documentação de plantas em campo.',
                              ),
                            ],
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(FoliumTheme.space8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(
                              FoliumTheme.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            Icons.devices,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        title: Text(l10n.deviceId),
                        subtitle: Text(
                          settings.deviceId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildModernCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: FoliumTheme.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _RainModeTile extends ConsumerWidget {
  final Settings settings;

  const _RainModeTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(
          Icons.water_drop,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(l10n.rainModeTitle),
      subtitle: Text(l10n.rainModeSubtitle),
      value: settings.rainModeEnabled,
      onChanged: (value) async {
        await ref.read(rainModeNotifierProvider.notifier).setEnabled(value);
      },
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  final Settings settings;

  const _LanguageTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(Icons.language, color: colorScheme.tertiary),
      ),
      title: Text(l10n.language),
      subtitle: Text(_getLanguageName(l10n, settings.localeCode)),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) {
            final dl10n = AppLocalizations.of(context)!;
            return SimpleDialog(
              title: Text(dl10n.selectLanguage),
              children: [
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 'pt'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.portugueseBR),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 'en'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.english),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 'es'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.spanish),
                  ),
                ),
              ],
            );
          },
        );

        if (selected != null && selected != settings.localeCode) {
          await notifier.setLocale(selected);
        }
      },
    );
  }

  String _getLanguageName(AppLocalizations l10n, String code) {
    switch (code) {
      case 'pt':
        return l10n.portugueseBR;
      case 'en':
        return l10n.english;
      case 'es':
        return l10n.spanish;
      default:
        return code;
    }
  }
}

class _MapProviderTile extends ConsumerWidget {
  final Settings settings;

  const _MapProviderTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.map),
      title: Text(l10n.mapProvider),
      subtitle: Text(_getProviderName(l10n, settings.mapProvider)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<MapProvider>(
          context: context,
          builder: (context) {
            final dl10n = AppLocalizations.of(context)!;
            return SimpleDialog(
              title: Text(dl10n.selectMapProvider),
              children: MapProvider.values.map((provider) {
                return SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, provider),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(_getProviderName(dl10n, provider)),
                  ),
                );
              }).toList(),
            );
          },
        );

        if (selected != null && selected != settings.mapProvider) {
          await notifier.setMapProvider(selected);
        }
      },
    );
  }

  String _getProviderName(AppLocalizations l10n, MapProvider provider) {
    switch (provider) {
      case MapProvider.openStreetMap:
        return 'OpenStreetMap';
      case MapProvider.mapboxStreets:
        return 'Mapbox Streets';
      case MapProvider.mapboxSatellite:
        return l10n.mapboxSatellite;
    }
  }
}

class _MapCacheTile extends ConsumerWidget {
  final Settings settings;

  const _MapCacheTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.sd_storage),
      title: Text(l10n.mapCacheRadius),
      subtitle: Text('${settings.mapCacheRadius.toStringAsFixed(1)} km'),
      trailing: SizedBox(
        width: 150,
        child: Slider(
          value: settings.mapCacheRadius,
          min: 1,
          max: 50,
          divisions: 49,
          label: '${settings.mapCacheRadius.toStringAsFixed(1)} km',
          onChanged: (value) async {
            final updatedSettings = settings..mapCacheRadius = value;
            await notifier.updateSettings(updatedSettings);
          },
        ),
      ),
    );
  }
}

class _AutoCacheTile extends ConsumerWidget {
  final Settings settings;

  const _AutoCacheTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.cached),
      title: Text(l10n.autoCache),
      subtitle: Text(l10n.autoDownloadTiles),
      value: settings.autoCache,
      onChanged: (value) async {
        final updatedSettings = settings..autoCache = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

class _AutoSaveTile extends ConsumerWidget {
  final Settings settings;

  const _AutoSaveTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.save),
      title: Text(l10n.autoSaveInterval),
      subtitle: Text(
        settings.autoSaveInterval == 0
            ? l10n.disabled
            : l10n.nSeconds(settings.autoSaveInterval),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<int>(
          context: context,
          builder: (context) {
            final dl10n = AppLocalizations.of(context)!;
            return SimpleDialog(
              title: Text(dl10n.autoSaveInterval),
              children: [
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.disabled),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.nSeconds(15)),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.nSeconds(30)),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.nSeconds(60)),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 120),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.nMinutes(2)),
                  ),
                ),
              ],
            );
          },
        );

        if (selected != null && selected != settings.autoSaveInterval) {
          await notifier.setAutoSaveInterval(selected);
        }
      },
    );
  }
}

class _PhotoQualityTile extends ConsumerWidget {
  final Settings settings;

  const _PhotoQualityTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.high_quality),
      title: Text(l10n.compressionQuality),
      subtitle: Text('${settings.photoCompressionQuality}%'),
      trailing: SizedBox(
        width: 150,
        child: Slider(
          value: settings.photoCompressionQuality.toDouble(),
          min: 30,
          max: 100,
          divisions: 14,
          label: '${settings.photoCompressionQuality}%',
          onChanged: (value) async {
            await notifier.setPhotoCompressionQuality(value.round());
          },
        ),
      ),
    );
  }
}

class _PreserveExifTile extends ConsumerWidget {
  final Settings settings;

  const _PreserveExifTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.info),
      title: Text(l10n.preserveExifTitle),
      subtitle: Text(l10n.preserveExifSubtitle),
      value: settings.preserveExif,
      onChanged: (value) async {
        final updatedSettings = settings..preserveExif = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

class _PlantNetApiKeyTile extends ConsumerWidget {
  final Settings settings;

  const _PlantNetApiKeyTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.key_outlined),
      title: Text(l10n.plantNetApiKeyTitle),
      subtitle: Text(
        settings.plantnetApiKey.trim().isEmpty
            ? l10n.plantNetApiKeyNotConfigured
            : l10n.plantNetApiKeyConfigured,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (context) =>
              _PlantNetApiKeyDialog(currentValue: settings.plantnetApiKey),
        );

        if (result != null && result != settings.plantnetApiKey) {
          final updatedSettings = settings..plantnetApiKey = result.trim();
          await notifier.updateSettings(updatedSettings);
        }
      },
    );
  }
}

class _TranscriptionTile extends ConsumerWidget {
  final Settings settings;

  const _TranscriptionTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.mic),
      title: Text(l10n.transcriptionTitle),
      subtitle: Text(l10n.transcriptionSubtitle),
      value: settings.transcriptionEnabled,
      onChanged: (value) async {
        final updatedSettings = settings..transcriptionEnabled = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

class _TranscriptionLocaleTile extends ConsumerWidget {
  final Settings settings;

  const _TranscriptionLocaleTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.record_voice_over),
      title: Text(l10n.transcriptionLanguage),
      subtitle: Text(_getLanguageName(l10n, settings.transcriptionLocale)),
      trailing: const Icon(Icons.chevron_right),
      enabled: settings.transcriptionEnabled,
      onTap: settings.transcriptionEnabled
          ? () async {
              final selected = await showDialog<String>(
                context: context,
                builder: (context) {
                  final dl10n = AppLocalizations.of(context)!;
                  return SimpleDialog(
                    title: Text(dl10n.transcriptionLanguage),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'pt'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(dl10n.portugueseBR),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'en'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(dl10n.english),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, 'es'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(dl10n.spanish),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (selected != null &&
                  selected != settings.transcriptionLocale) {
                final updatedSettings = settings
                  ..transcriptionLocale = selected;
                await notifier.updateSettings(updatedSettings);
              }
            }
          : null,
    );
  }

  String _getLanguageName(AppLocalizations l10n, String code) {
    switch (code) {
      case 'pt':
        return l10n.portugueseBR;
      case 'en':
        return l10n.english;
      case 'es':
        return l10n.spanish;
      default:
        return code;
    }
  }
}

class _AudioQualityTile extends ConsumerWidget {
  final Settings settings;

  const _AudioQualityTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.audiotrack),
      title: Text(l10n.audioQualityTitle),
      subtitle: Text(_getQualityName(l10n, settings.audioQuality)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) {
            final dl10n = AppLocalizations.of(context)!;
            return SimpleDialog(
              title: Text(dl10n.audioQualityTitle),
              children: [
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 'low'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.audioQualityLow),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 'medium'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.audioQualityMedium),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, 'high'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.audioQualityHigh),
                  ),
                ),
              ],
            );
          },
        );

        if (selected != null && selected != settings.audioQuality) {
          final updatedSettings = settings..audioQuality = selected;
          await notifier.updateSettings(updatedSettings);
        }
      },
    );
  }

  String _getQualityName(AppLocalizations l10n, String quality) {
    switch (quality) {
      case 'low':
        return l10n.audioQualityLowShort;
      case 'medium':
        return l10n.audioQualityMedium;
      case 'high':
        return l10n.audioQualityHighShort;
      default:
        return quality;
    }
  }
}

class _CloudBackupEnabledTile extends ConsumerWidget {
  final Settings settings;

  const _CloudBackupEnabledTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.cloud_upload),
      title: Text(l10n.cloudBackup),
      subtitle: Text(l10n.syncAutomatically),
      value: settings.cloudBackupEnabled,
      onChanged: (value) async {
        await notifier.setCloudBackupEnabled(value);
      },
    );
  }
}

class _CloudBackupProviderTile extends ConsumerWidget {
  final Settings settings;

  const _CloudBackupProviderTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.cloud_queue),
      title: Text(l10n.backupProvider),
      subtitle: Text(_getProviderName(settings.cloudBackupProvider, l10n)),
      trailing: const Icon(Icons.chevron_right),
      enabled: settings.cloudBackupEnabled,
      onTap: settings.cloudBackupEnabled
          ? () async {
              final selected = await showDialog<CloudBackupProvider>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(l10n.backupProvider),
                  children: CloudBackupProvider.values.map((provider) {
                    return SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, provider),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(_getProviderName(provider, l10n)),
                      ),
                    );
                  }).toList(),
                ),
              );

              if (selected != null &&
                  selected != settings.cloudBackupProvider) {
                await notifier.setCloudBackupProvider(selected);
              }
            }
          : null,
    );
  }

  String _getProviderName(CloudBackupProvider provider, AppLocalizations l10n) {
    switch (provider) {
      case CloudBackupProvider.none:
        return l10n.providerNone;
      case CloudBackupProvider.googleDrive:
        return 'Google Drive';
      case CloudBackupProvider.dropbox:
        return 'Dropbox';
    }
  }
}

class _CloudBackupWifiOnlyTile extends ConsumerWidget {
  final Settings settings;

  const _CloudBackupWifiOnlyTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Opacity(
      opacity: settings.cloudBackupEnabled ? 1.0 : 0.5,
      child: SwitchListTile(
        secondary: const Icon(Icons.wifi),
        title: Text(l10n.wifiOnly),
        subtitle: Text(l10n.backupOnlyWifi),
        value: settings.cloudBackupWifiOnly,
        onChanged: settings.cloudBackupEnabled
            ? (value) async {
                final updatedSettings = settings..cloudBackupWifiOnly = value;
                await notifier.updateSettings(updatedSettings);
              }
            : null,
      ),
    );
  }
}

class _BackupActionButtons extends ConsumerStatefulWidget {
  final Settings settings;

  const _BackupActionButtons({required this.settings});

  @override
  ConsumerState<_BackupActionButtons> createState() =>
      _BackupActionButtonsState();
}

class _BackupActionButtonsState extends ConsumerState<_BackupActionButtons> {
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backupService = ref.read(googleDriveBackupServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Signed-in status
        if (backupService.isSignedIn && backupService.currentUserEmail != null)
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: colorScheme.primary,
            ),
            title: Text(
              l10n.signedInAs(backupService.currentUserEmail!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TextButton(
              onPressed: () async {
                await backupService.signOut();
                if (mounted) setState(() {});
              },
              child: Text(l10n.signOut),
            ),
          ),

        // Backup Now button
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FoliumTheme.space16,
            vertical: FoliumTheme.space8,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isBackingUp
                  ? null
                   : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() => _isBackingUp = true);
                      try {
                        await backupService.backup();
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(l10n.backupSuccess),
                              backgroundColor: FoliumTheme.success,
                            ),
                          );
                          // Refresh to show updated lastCloudBackup
                          ref.invalidate(settingsNotifierProvider);
                        }
                      } catch (e) {
                        if (mounted) {
                          final errorMsg = _localizeError(e.toString(), l10n);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(l10n.backupFailed(errorMsg)),
                              backgroundColor: colorScheme.error,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isBackingUp = false);
                      }
                    },
              icon: _isBackingUp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(
                _isBackingUp ? l10n.backupInProgress : l10n.backupNow,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: FoliumTheme.space12,
                ),
              ),
            ),
          ),
        ),

        // Restore button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FoliumTheme.space16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isRestoring
                  ? null
                  : () => _confirmAndRestore(l10n, backupService),
              icon: _isRestoring
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(
                _isRestoring ? l10n.restoreInProgress : l10n.restoreFromCloud,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(
                  vertical: FoliumTheme.space12,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: FoliumTheme.space8),
      ],
    );
  }

  Future<void> _confirmAndRestore(
    AppLocalizations l10n,
    GoogleDriveBackupService backupService,
  ) async {
    final initialConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Text(l10n.restoreConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (initialConfirmed != true || !mounted) return;

    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.restoreFromCloud,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeOverwriteConfirmTitle,
      confirmMessage: l10n.restoreConfirmBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.confirm,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: Theme.of(context).colorScheme.primary,
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isRestoring = true);
    try {
      final result = await backupService.restore();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.restoreResult(
                result.imported,
                result.updated,
                result.skipped,
              ),
            ),
            backgroundColor: FoliumTheme.success,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = _localizeError(e.toString(), l10n);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  String _localizeError(String error, AppLocalizations l10n) {
    if (error.contains('noInternetConnection')) {
      return l10n.noInternetConnection;
    }
    if (error.contains('wifiRequired')) return l10n.wifiRequired;
    if (error.contains('noBackupFound')) return l10n.noBackupFound;
    return error;
  }
}

class _PaginationSizeTile extends ConsumerWidget {
  final Settings settings;

  const _PaginationSizeTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.view_list),
      title: Text(l10n.paginationSize),
      subtitle: Text(l10n.nItems(settings.paginationSize)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<int>(
          context: context,
          builder: (context) {
            final dl10n = AppLocalizations.of(context)!;
            return SimpleDialog(
              title: Text(dl10n.paginationSize),
              children: [10, 20, 30, 50, 100].map((size) {
                return SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, size),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(dl10n.nItems(size)),
                  ),
                );
              }).toList(),
            );
          },
        );

        if (selected != null && selected != settings.paginationSize) {
          final updatedSettings = settings..paginationSize = selected;
          await notifier.updateSettings(updatedSettings);
        }
      },
    );
  }
}

class _ThumbnailCacheTile extends ConsumerWidget {
  final Settings settings;

  const _ThumbnailCacheTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.image),
      title: Text(l10n.thumbnailCacheTitle),
      subtitle: Text(l10n.thumbnailCacheSubtitle),
      value: settings.enableThumbnailCache,
      onChanged: (value) async {
        final updatedSettings = settings..enableThumbnailCache = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

// Registry Identifier Tiles
class _UserInitialsTile extends ConsumerWidget {
  final Settings settings;
  const _UserInitialsTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(Icons.person, color: colorScheme.primary),
      ),
      title: Text(l10n.userInitialsTitle),
      subtitle: Text(settings.userInitials),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (context) =>
              _InitialsDialog(currentInitials: settings.userInitials),
        );

        if (result != null && result != settings.userInitials) {
          final updatedSettings = settings..userInitials = result;
          await notifier.updateSettings(updatedSettings);
        }
      },
    );
  }
}

class _LastRegistryNumberTile extends ConsumerWidget {
  final Settings settings;
  const _LastRegistryNumberTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final nextNumber = settings.lastRegistryNumber + 1;
    final nextId =
        '${settings.userInitials}${nextNumber.toString().padLeft(6, '0')}';

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(Icons.tag, color: Theme.of(context).colorScheme.secondary),
      ),
      title: Text(l10n.lastRegistryNumberTitle),
      subtitle: Text('${settings.lastRegistryNumber} • ${l10n.nextLabel(nextId)}'),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        final result = await showDialog<int>(
          context: context,
          builder: (context) =>
              _RegistryNumberDialog(currentNumber: settings.lastRegistryNumber),
        );

        if (result != null && result != settings.lastRegistryNumber) {
          final updatedSettings = settings..lastRegistryNumber = result;
          await notifier.updateSettings(updatedSettings);
        }
      },
    );
  }
}

class _AutoGenerateIdentifierTile extends ConsumerWidget {
  final Settings settings;
  const _AutoGenerateIdentifierTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: FoliumTheme.warningContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: const Icon(Icons.auto_awesome, color: FoliumTheme.warning),
      ),
      title: Text(l10n.autoGenerateTitle),
      subtitle: Text(l10n.autoGenerateSubtitle),
      value: settings.autoGenerateIdentifier,
      activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
      onChanged: (value) async {
        final updatedSettings = settings..autoGenerateIdentifier = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

// Dialogs
class _InitialsDialog extends StatefulWidget {
  final String currentInitials;
  const _InitialsDialog({required this.currentInitials});

  @override
  State<_InitialsDialog> createState() => _InitialsDialogState();
}

class _InitialsDialogState extends State<_InitialsDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentInitials);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final value = _controller.text.trim().toUpperCase();
    if (value.isEmpty) {
      setState(() => _errorText = l10n.initialsCannotBeEmpty);
      return false;
    }
    if (!RegExp(r'^[A-Z]{1,4}$').hasMatch(value)) {
      setState(() => _errorText = l10n.initialsFormatError);
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.userInitialsTitle),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: l10n.initialsLabel,
          hintText: l10n.initialsHint,
          errorText: _errorText,
          helperText: l10n.initialsHelper,
        ),
        textCapitalization: TextCapitalization.characters,
        maxLength: 4,
        onChanged: (_) {
          if (_errorText != null) _validate(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_validate(context)) {
              Navigator.pop(context, _controller.text.trim().toUpperCase());
            }
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _RegistryNumberDialog extends StatefulWidget {
  final int currentNumber;
  const _RegistryNumberDialog({required this.currentNumber});

  @override
  State<_RegistryNumberDialog> createState() => _RegistryNumberDialogState();
}

class _RegistryNumberDialogState extends State<_RegistryNumberDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentNumber.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _errorText = l10n.numberCannotBeEmpty);
      return false;
    }
    final number = int.tryParse(value);
    if (number == null || number < 0) {
      setState(() => _errorText = l10n.enterValidNumber);
      return false;
    }
    if (number > 999999) {
      setState(() => _errorText = l10n.numberTooLarge);
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  String _getHelperText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return l10n.enterLastRegistryNumber;
    }

    final number = int.tryParse(value);
    if (number == null) {
      return l10n.digitsOnly;
    }

    if (number < 0 || number > 999999) {
      return l10n.numberBetweenError;
    }

    try {
      return l10n.nextRegistryWillUse(number + 1);
    } catch (e) {
      return l10n.errorCalcNext;
    }
  }

  @override
          Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.lastRegistryNumberTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.numberLabel,
              hintText: l10n.numberHint,
              errorText: _errorText,
              helperText: _getHelperText(context),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              if (_errorText != null) _validate(context);
              setState(() {}); // Update helper text
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.changeNumberWarning,
            style: const TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_validate(context)) {
              Navigator.pop(context, int.parse(_controller.text.trim()));
            }
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _PlantNetApiKeyDialog extends StatefulWidget {
  final String currentValue;

  const _PlantNetApiKeyDialog({required this.currentValue});

  @override
  State<_PlantNetApiKeyDialog> createState() => _PlantNetApiKeyDialogState();
}

class _PlantNetApiKeyDialogState extends State<_PlantNetApiKeyDialog> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.plantNetApiKeyTitle),
      content: TextField(
        controller: _controller,
        obscureText: _obscureText,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          labelText: l10n.plantNetApiKeyLabel,
          hintText: l10n.plantNetApiKeyHint,
          helperText: l10n.plantNetApiKeyHelper,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

// Identifier Management Tile
class _IdentifierManagementTile extends StatelessWidget {
  const _IdentifierManagementTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(
          Icons.playlist_add_check,
          color: colorScheme.tertiary,
        ),
      ),
      title: Text(l10n.manageIdentifiers),
      subtitle: Text(l10n.manageIdentifiersSubtitle),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IdentifierManagementScreen(),
          ),
        );
      },
    );
  }
}

class _CollectionTemplatesTile extends StatelessWidget {
  const _CollectionTemplatesTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(Icons.library_books, color: colorScheme.primary),
      ),
      title: Text(l10n.collectionTemplatesTitle),
      subtitle: Text(l10n.collectionTemplatesSubtitle),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TemplatesScreen()),
        );
      },
    );
  }
}

class _AccountSection extends ConsumerWidget {
  final Settings settings;
  const _AccountSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: FoliumTheme.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (authState is AuthAuthenticated) ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: FoliumTheme.successContainer,
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: const Icon(Icons.person, color: FoliumTheme.success),
              ),
              title: Text(
                authState.user.name.isNotEmpty
                    ? authState.user.name
                    : authState.user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                authState.user.email.isNotEmpty
                    ? authState.user.email
                    : l10n.connected,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(Icons.logout, color: colorScheme.error),
              ),
              title: Text(l10n.signOut),
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).logout();
              },
            ),
          ] else ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(Icons.login, color: colorScheme.primary),
              ),
              title: Text(l10n.signIn),
              subtitle: Text(l10n.syncCloud),
              trailing: Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SyncSection extends ConsumerWidget {
  final Settings settings;
  const _SyncSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final syncState = ref.watch(syncNotifierProvider);
    final isAuthenticated = authState is AuthAuthenticated;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: FoliumTheme.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(FoliumTheme.space8),
              decoration: BoxDecoration(
                color: syncState.isSyncing
                    ? colorScheme.primaryContainer
                    : isAuthenticated
                    ? FoliumTheme.successContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
              ),
              child: syncState.isSyncing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.sync,
                      color: isAuthenticated
                          ? FoliumTheme.success
                          : colorScheme.onSurfaceVariant,
                    ),
            ),
            title: Text(
              syncState.isSyncing ? l10n.syncing2 : l10n.syncNow,
            ),
            subtitle: Text(
              !isAuthenticated
                  ? l10n.loginToSync
                  : syncState.lastSyncAt != null
                  ? l10n.lastSync(_formatDateTime(syncState.lastSyncAt!))
                  : l10n.neverSynced,
            ),
            trailing: isAuthenticated && !syncState.isSyncing
                ? Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  )
                : null,
            onTap: isAuthenticated && !syncState.isSyncing
                ? () {
                    ref
                        .read(syncNotifierProvider.notifier)
                        .sync(deviceId: settings.deviceId);
                  }
                : null,
          ),
          if (syncState.lastError != null) ...[
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(Icons.error_outline, color: colorScheme.error),
              ),
              title: Text(l10n.syncErrorTitle),
              subtitle: Text(
                syncState.lastError!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          if (syncState.lastResult != null) ...[
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                ),
              ),
              title: Text(l10n.lastSyncResult),
              subtitle: Text(
                l10n.syncResultSummary(
                  syncState.lastResult!.pushed,
                  syncState.lastResult!.pulled,
                ) +
                (syncState.lastResult!.conflicts > 0
                    ? l10n.syncResultConflicts(syncState.lastResult!.conflicts)
                    : ''),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        'às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _HighContrastTile extends ConsumerWidget {
  final Settings settings;

  const _HighContrastTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(
          Icons.contrast,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(l10n.highContrast),
      subtitle: Text(l10n.highContrastSubtitle),
      value: settings.highContrastMode,
      onChanged: (value) async {
        final updatedSettings = settings..highContrastMode = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

class _FontScaleTile extends ConsumerWidget {
  final Settings settings;

  const _FontScaleTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: Icon(
          Icons.text_fields,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(l10n.fontSize),
      subtitle: Text('${(settings.fontScale * 100).toInt()}%'),
      trailing: SizedBox(
        width: 150,
        child: Slider(
          value: settings.fontScale,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          label: '${(settings.fontScale * 100).toInt()}%',
          onChanged: (value) async {
            final updatedSettings = settings..fontScale = value;
            await notifier.updateSettings(updatedSettings);
          },
        ),
      ),
    );
  }
}
