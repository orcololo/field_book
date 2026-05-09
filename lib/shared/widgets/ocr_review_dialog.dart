import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class OcrReviewDialog extends StatefulWidget {
  final Map<String, String> initialFields;

  const OcrReviewDialog({super.key, required this.initialFields});

  @override
  State<OcrReviewDialog> createState() => _OcrReviewDialogState();
}

class _OcrReviewDialogState extends State<OcrReviewDialog> {
  static const List<String> _fieldOrder = [
    'scientificName',
    'family',
    'collectorName',
    'collectionNumber',
    'collectionDate',
    'locality',
    'latitude',
    'longitude',
  ];

  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final entry in widget.initialFields.entries)
        entry.key: TextEditingController(text: entry.value),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orderedKeys = [
      ..._fieldOrder.where(_controllers.containsKey),
      ..._controllers.keys.where((key) => !_fieldOrder.contains(key)),
    ];

    return AlertDialog(
      title: Text(l10n.ocrReviewTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final key in orderedKeys) ...[
                TextField(
                  controller: _controllers[key],
                  textCapitalization: _textCapitalizationFor(key),
                  keyboardType: _keyboardTypeFor(key),
                  decoration: InputDecoration(
                    labelText: _labelFor(l10n, key),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              for (final entry in _controllers.entries)
                entry.key: entry.value.text.trim(),
            });
          },
          child: Text(l10n.ocrConfirmFill),
        ),
      ],
    );
  }

  String _labelFor(AppLocalizations l10n, String key) {
    switch (key) {
      case 'scientificName':
        return l10n.scientificName;
      case 'family':
        return l10n.family;
      case 'collectorName':
        return l10n.collector;
      case 'collectionNumber':
        return l10n.collectorNumber;
      case 'collectionDate':
        return l10n.collectionDate;
      case 'locality':
        return l10n.locality;
      case 'latitude':
        return l10n.latitude;
      case 'longitude':
        return l10n.longitude;
      default:
        return key;
    }
  }

  TextCapitalization _textCapitalizationFor(String key) {
    switch (key) {
      case 'scientificName':
      case 'family':
      case 'collectorName':
      case 'locality':
        return TextCapitalization.words;
      default:
        return TextCapitalization.none;
    }
  }

  TextInputType _keyboardTypeFor(String key) {
    switch (key) {
      case 'latitude':
      case 'longitude':
        return const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        );
      default:
        return TextInputType.text;
    }
  }
}
