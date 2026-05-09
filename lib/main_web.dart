import 'package:flutter/material.dart';
import 'core/theme/folium_theme.dart';

void main() {
  runApp(const WebNotSupportedApp());
}

class WebNotSupportedApp extends StatelessWidget {
  const WebNotSupportedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caderno de Campo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: FoliumTheme.primaryMain,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 100,
                  color: FoliumTheme.warning,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Plataforma Web Não Suportada',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'O Caderno de Campo requer recursos nativos da plataforma '
                  '(câmera, GPS, banco de dados local, acesso ao sistema de arquivos) '
                  'que não estão disponíveis em navegadores web.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Por favor, use a versão mobile (Android/iOS) ou desktop '
                  '(Windows/macOS/Linux) deste aplicativo.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
