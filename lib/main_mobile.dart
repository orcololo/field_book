import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/database/isar_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/map_service.dart';
import 'core/theme/folium_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

const _defaultLocale = Locale('pt');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database
  await IsarService.instance.isar;

  // Initialize map tile caching
  await MapService.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return settingsAsync.when(
      loading: () => const MaterialApp(
        locale: _defaultLocale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('pt'),
          Locale('en'),
          Locale('es'),
        ],
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => MaterialApp(
        locale: _defaultLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt'),
          Locale('en'),
          Locale('es'),
        ],
        theme: FoliumTheme.getLightTheme(),
        darkTheme: FoliumTheme.getDarkTheme(),
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $error'),
          ),
        ),
      ),
      data: (settings) {
        return MaterialApp(
          title: 'Folium',
          debugShowCheckedModeBanner: false,
          
          // Localization
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt'),
            Locale('en'),
            Locale('es'),
          ],
          locale: Locale(settings.localeCode),
          
          // Folium Eco-Modern Theme
          theme: FoliumTheme.getLightTheme(
            fontScale: settings.fontScale,
            highContrast: settings.highContrastMode,
          ),
          darkTheme: FoliumTheme.getDarkTheme(
            fontScale: settings.fontScale,
            highContrast: settings.highContrastMode,
          ),
          
          // Home screen (or onboarding on first launch)
          home: settings.hasCompletedOnboarding
              ? const HomeScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}
