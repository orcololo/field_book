import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../models/settings.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/shimmer_loading.dart';
import '../../export_import/screens/export_import_screen.dart';
import '../../onboarding/screens/onboarding_screen.dart';
import '../../../core/services/google_drive_backup_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/sync_provider.dart';
import '../../auth/screens/login_screen.dart';
import 'identifier_management_screen.dart';

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
          padding: const EdgeInsets.only(
            top: 100,
            left: FoliumTheme.space16,
            right: FoliumTheme.space16,
          ),
          itemBuilder: (context, index) {
            return ShimmerLoading(child: ShimmerPlaceholders.listItem());
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
              padding: const EdgeInsets.only(
                left: FoliumTheme.space16,
                right: FoliumTheme.space16,
                top: 96, // Account for glass app bar
                bottom:
                    140, // Extra bottom padding for navigation bar + safe area + overflow fix
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader(context, l10n.general),
                  const SizedBox(height: FoliumTheme.space8),
                  _buildModernCard(
                    context,
                    children: [_LanguageTile(settings: settings)],
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
                    children: [_AutoSaveTile(settings: settings)],
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

class _LanguageTile extends ConsumerWidget {
  final Settings settings;

  const _LanguageTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: FoliumTheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: const Icon(Icons.language, color: FoliumTheme.tertiaryMain),
      ),
      title: const Text('Idioma'),
      subtitle: Text(_getLanguageName(settings.localeCode)),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Selecionar Idioma'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'pt'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Português (BR)'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'en'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('English'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'es'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Español'),
                ),
              ),
            ],
          ),
        );

        if (selected != null && selected != settings.localeCode) {
          await notifier.setLocale(selected);
        }
      },
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'pt':
        return 'Português (BR)';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.map),
      title: const Text('Provedor de Mapas'),
      subtitle: Text(_getProviderName(settings.mapProvider)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<MapProvider>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Selecionar Provedor'),
            children: MapProvider.values.map((provider) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, provider),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(_getProviderName(provider)),
                ),
              );
            }).toList(),
          ),
        );

        if (selected != null && selected != settings.mapProvider) {
          await notifier.setMapProvider(selected);
        }
      },
    );
  }

  String _getProviderName(MapProvider provider) {
    switch (provider) {
      case MapProvider.openStreetMap:
        return 'OpenStreetMap';
      case MapProvider.mapboxStreets:
        return 'Mapbox Streets';
      case MapProvider.mapboxSatellite:
        return 'Mapbox Satélite';
    }
  }
}

class _MapCacheTile extends ConsumerWidget {
  final Settings settings;

  const _MapCacheTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.sd_storage),
      title: const Text('Raio do Cache do Mapa'),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.cached),
      title: const Text('Cache Automático'),
      subtitle: const Text('Baixar tiles automaticamente'),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.save),
      title: const Text('Intervalo de Auto-salvamento'),
      subtitle: Text(
        settings.autoSaveInterval == 0
            ? 'Desativado'
            : '${settings.autoSaveInterval} segundos',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<int>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Intervalo de Auto-salvamento'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 0),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Desativado'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 15),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('15 segundos'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('30 segundos'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 60),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('60 segundos'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 120),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('2 minutos'),
                ),
              ),
            ],
          ),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.high_quality),
      title: const Text('Qualidade de Compressão'),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.info),
      title: const Text('Preservar Metadados EXIF'),
      subtitle: const Text('Manter informações de GPS e câmera'),
      value: settings.preserveExif,
      onChanged: (value) async {
        final updatedSettings = settings..preserveExif = value;
        await notifier.updateSettings(updatedSettings);
      },
    );
  }
}

class _TranscriptionTile extends ConsumerWidget {
  final Settings settings;

  const _TranscriptionTile({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.mic),
      title: const Text('Transcrição de Áudio'),
      subtitle: const Text('Converter voz em texto'),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.record_voice_over),
      title: const Text('Idioma da Transcrição'),
      subtitle: Text(_getLanguageName(settings.transcriptionLocale)),
      trailing: const Icon(Icons.chevron_right),
      enabled: settings.transcriptionEnabled,
      onTap: settings.transcriptionEnabled
          ? () async {
              final selected = await showDialog<String>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Idioma da Transcrição'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'pt'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Português (BR)'),
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'en'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('English'),
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'es'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Español'),
                      ),
                    ),
                  ],
                ),
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

  String _getLanguageName(String code) {
    switch (code) {
      case 'pt':
        return 'Português (BR)';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.audiotrack),
      title: const Text('Qualidade de Áudio'),
      subtitle: Text(_getQualityName(settings.audioQuality)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Qualidade de Áudio'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'low'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Baixa (menor tamanho)'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'medium'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Média'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'high'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Alta (melhor qualidade)'),
                ),
              ),
            ],
          ),
        );

        if (selected != null && selected != settings.audioQuality) {
          final updatedSettings = settings..audioQuality = selected;
          await notifier.updateSettings(updatedSettings);
        }
      },
    );
  }

  String _getQualityName(String quality) {
    switch (quality) {
      case 'low':
        return 'Baixa';
      case 'medium':
        return 'Média';
      case 'high':
        return 'Alta';
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

    return Column(
      children: [
        // Signed-in status
        if (backupService.isSignedIn && backupService.currentUserEmail != null)
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: FoliumTheme.primaryMain,
            ),
            title: Text(l10n.signedInAs(backupService.currentUserEmail!)),
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
                      setState(() => _isBackingUp = true);
                      try {
                        await backupService.backup();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.backupFailed(errorMsg)),
                              backgroundColor: FoliumTheme.error,
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
                backgroundColor: FoliumTheme.primaryMain,
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
                foregroundColor: FoliumTheme.primaryMain,
                side: const BorderSide(color: FoliumTheme.primaryMain),
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
    final confirmed = await showDialog<bool>(
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
              backgroundColor: FoliumTheme.primaryMain,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
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
          SnackBar(content: Text(errorMsg), backgroundColor: FoliumTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  String _localizeError(String error, AppLocalizations l10n) {
    if (error.contains('noInternetConnection'))
      return l10n.noInternetConnection;
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.view_list),
      title: const Text('Itens por Página'),
      subtitle: Text('${settings.paginationSize} itens'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showDialog<int>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Itens por Página'),
            children: [10, 20, 30, 50, 100].map((size) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, size),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('$size itens'),
                ),
              );
            }).toList(),
          ),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return SwitchListTile(
      secondary: const Icon(Icons.image),
      title: const Text('Cache de Miniaturas'),
      subtitle: const Text('Melhorar performance das listas'),
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
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: FoliumTheme.primaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: const Icon(Icons.person, color: FoliumTheme.primaryMain),
      ),
      title: const Text('Iniciais do Usuário'),
      subtitle: Text(settings.userInitials),
      trailing: const Icon(
        Icons.chevron_right,
        color: FoliumTheme.onSurfaceVariant,
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
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final nextNumber = settings.lastRegistryNumber + 1;
    final nextId =
        '${settings.userInitials}${nextNumber.toString().padLeft(6, '0')}';

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: FoliumTheme.secondaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: const Icon(Icons.tag, color: FoliumTheme.secondaryMain),
      ),
      title: const Text('Último Número de Registro'),
      subtitle: Text('${settings.lastRegistryNumber} • Próximo: $nextId'),
      trailing: const Icon(
        Icons.chevron_right,
        color: FoliumTheme.onSurfaceVariant,
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
      title: const Text('Gerar Automaticamente'),
      subtitle: const Text('Criar identificador ao salvar registro'),
      value: settings.autoGenerateIdentifier,
      activeTrackColor: FoliumTheme.primaryContainer,
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

  bool _validate() {
    final value = _controller.text.trim().toUpperCase();
    if (value.isEmpty) {
      setState(() => _errorText = 'Iniciais não podem estar vazias');
      return false;
    }
    if (!RegExp(r'^[A-Z]{1,4}$').hasMatch(value)) {
      setState(() => _errorText = 'Use 1-4 letras maiúsculas');
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Iniciais do Usuário'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Iniciais',
          hintText: 'Ex: RC, ABC',
          errorText: _errorText,
          helperText: '1-4 letras maiúsculas',
        ),
        textCapitalization: TextCapitalization.characters,
        maxLength: 4,
        onChanged: (_) {
          if (_errorText != null) _validate();
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (_validate()) {
              Navigator.pop(context, _controller.text.trim().toUpperCase());
            }
          },
          child: const Text('Salvar'),
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

  bool _validate() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _errorText = 'Número não pode estar vazio');
      return false;
    }
    final number = int.tryParse(value);
    if (number == null || number < 0) {
      setState(() => _errorText = 'Digite um número válido (≥ 0)');
      return false;
    }
    if (number > 999999) {
      setState(() => _errorText = 'Número muito grande (máx: 999999)');
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  String _getHelperText() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return 'Digite o último número de registro';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Digite apenas números';
    }

    if (number < 0 || number > 999999) {
      return 'Número deve estar entre 0 e 999999';
    }

    try {
      return 'Próximo registro usará: ${number + 1}';
    } catch (e) {
      return 'Erro ao calcular próximo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Último Número de Registro'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Número',
              hintText: 'Ex: 0, 40, 1000',
              errorText: _errorText,
              helperText: _getHelperText(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              if (_errorText != null) _validate();
              setState(() {}); // Update helper text
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Alterar este número afetará os próximos registros criados.',
            style: TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (_validate()) {
              Navigator.pop(context, int.parse(_controller.text.trim()));
            }
          },
          child: const Text('Salvar'),
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
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(FoliumTheme.space8),
        decoration: BoxDecoration(
          color: FoliumTheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
        ),
        child: const Icon(
          Icons.playlist_add_check,
          color: FoliumTheme.tertiaryMain,
        ),
      ),
      title: const Text('Gerenciar Identificadores'),
      subtitle: const Text('Atribuir identificadores a plantas existentes'),
      trailing: const Icon(
        Icons.chevron_right,
        color: FoliumTheme.onSurfaceVariant,
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

class _AccountSection extends ConsumerWidget {
  final Settings settings;
  const _AccountSection({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

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
              ),
              subtitle: Text(
                authState.user.email.isNotEmpty
                    ? authState.user.email
                    : 'Conectado',
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: FoliumTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(Icons.logout, color: FoliumTheme.error),
              ),
              title: const Text('Sair da conta'),
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).logout();
              },
            ),
          ] else ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: FoliumTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: const Icon(Icons.login, color: FoliumTheme.primaryMain),
              ),
              title: const Text('Entrar na conta'),
              subtitle: const Text('Sincronize seus dados na nuvem'),
              trailing: const Icon(
                Icons.chevron_right,
                color: FoliumTheme.onSurfaceVariant,
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
    final authState = ref.watch(authNotifierProvider);
    final syncState = ref.watch(syncNotifierProvider);
    final isAuthenticated = authState is AuthAuthenticated;

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
                    ? FoliumTheme.primaryContainer
                    : isAuthenticated
                    ? FoliumTheme.successContainer
                    : FoliumTheme.surfaceVariant,
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
                          : FoliumTheme.onSurfaceVariant,
                    ),
            ),
            title: Text(
              syncState.isSyncing ? 'Sincronizando...' : 'Sincronizar agora',
            ),
            subtitle: Text(
              !isAuthenticated
                  ? 'Faça login para sincronizar'
                  : syncState.lastSyncAt != null
                  ? 'Última: ${_formatDateTime(syncState.lastSyncAt!)}'
                  : 'Nunca sincronizado',
            ),
            trailing: isAuthenticated && !syncState.isSyncing
                ? const Icon(
                    Icons.chevron_right,
                    color: FoliumTheme.onSurfaceVariant,
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
                  color: FoliumTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(Icons.error_outline, color: FoliumTheme.error),
              ),
              title: const Text('Erro na sincronização'),
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
                  color: FoliumTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: FoliumTheme.primaryMain,
                ),
              ),
              title: const Text('Último resultado'),
              subtitle: Text(
                '${syncState.lastResult!.pushed} enviados, '
                '${syncState.lastResult!.pulled} recebidos'
                '${syncState.lastResult!.conflicts > 0 ? ', ${syncState.lastResult!.conflicts} conflitos' : ''}',
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
