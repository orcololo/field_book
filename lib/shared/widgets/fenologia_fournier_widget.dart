import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/folium_theme.dart';

class FenologiaFournierWidget extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const FenologiaFournierWidget({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<FenologiaFournierWidget> createState() => _FenologiaFournierWidgetState();
}

class _FenologiaFournierWidgetState extends State<FenologiaFournierWidget> {
  int _botao = 0;
  int _flor = 0;
  int _frutoImaturo = 0;
  int _frutoMaduro = 0;
  int _quedaFoliar = 0;

  @override
  void initState() {
    super.initState();
    _parseInitialValue();
  }

  void _parseInitialValue() {
    if (widget.initialValue == null || widget.initialValue!.isEmpty) return;
    
    // Ex: "botão:3,flor:2,fruto_imaturo:0,fruto_maduro:1,queda_foliar:0"
    final parts = widget.initialValue!.split(',');
    for (final part in parts) {
      final kv = part.split(':');
      if (kv.length != 2) continue;
      
      final key = kv[0];
      final value = int.tryParse(kv[1]) ?? 0;
      
      switch (key) {
        case 'botão':
          _botao = value;
          break;
        case 'flor':
          _flor = value;
          break;
        case 'fruto_imaturo':
          _frutoImaturo = value;
          break;
        case 'fruto_maduro':
          _frutoMaduro = value;
          break;
        case 'queda_foliar':
          _quedaFoliar = value;
          break;
      }
    }
  }

  void _notifyChange() {
    final result = 'botão:$_botao,flor:$_flor,fruto_imaturo:$_frutoImaturo,fruto_maduro:$_frutoMaduro,queda_foliar:$_quedaFoliar';
    widget.onChanged(result);
  }

  Widget _buildRow(String label, int value, ValueChanged<int?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  children: [
                    Text(index.toString(), style: const TextStyle(fontSize: 12)),
                    SizedBox(
                      width: 48,
                      height: 48, // 48dp min tap target
                      child: Radio<int>(
                        value: index,
                        groupValue: value,
                        onChanged: (v) {
                          if (v != null) {
                            onChanged(v);
                            _notifyChange();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: FoliumTheme.space12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(FoliumTheme.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.phenologyFournier,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: FoliumTheme.space16),
            _buildRow(l10n.fournierFlowerBud, _botao, (v) => setState(() => _botao = v!)),
            _buildRow(l10n.fournierOpenFlower, _flor, (v) => setState(() => _flor = v!)),
            _buildRow(l10n.fournierImmatureFruit, _frutoImaturo, (v) => setState(() => _frutoImaturo = v!)),
            _buildRow(l10n.fournierMatureFruit, _frutoMaduro, (v) => setState(() => _frutoMaduro = v!)),
            _buildRow(l10n.fournierLeafFall, _quedaFoliar, (v) => setState(() => _quedaFoliar = v!)),
          ],
        ),
      ),
    );
  }
}
