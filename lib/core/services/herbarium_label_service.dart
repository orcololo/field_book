import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/plant_record.dart';

class HerbariumLabelStrings {
  final String appTitle;
  final String title;
  final String family;
  final String collector;
  final String collectionDate;
  final String locality;
  final String gpsCoordinates;
  final String altitude;
  final String habitat;
  final String morphologicalNotes;
  final String notes;
  final String root;
  final String stem;
  final String leaf;
  final String flower;
  final String fruit;
  final String seed;
  final String notSpecified;

  const HerbariumLabelStrings({
    required this.appTitle,
    required this.title,
    required this.family,
    required this.collector,
    required this.collectionDate,
    required this.locality,
    required this.gpsCoordinates,
    required this.altitude,
    required this.habitat,
    required this.morphologicalNotes,
    required this.notes,
    required this.root,
    required this.stem,
    required this.leaf,
    required this.flower,
    required this.fruit,
    required this.seed,
    required this.notSpecified,
  });
}

class HerbariumLabelService {
  final HerbariumLabelStrings strings;

  const HerbariumLabelService({required this.strings});

  Future<Uint8List> generateLabel(PlantRecord record) async {
    final document = pw.Document();
    final qrCodeBytes = await _buildQrCode(record.uuid);
    final qrCodeImage =
        qrCodeBytes == null ? null : pw.MemoryImage(qrCodeBytes);

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        theme: pw.ThemeData.withFont(
          base: pw.Font.times(),
          bold: pw.Font.timesBold(),
          italic: pw.Font.timesItalic(),
        ),
        build: (context) {
          return pw.Column(
            children: [
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Expanded(child: _buildLabel(record, qrCodeImage)),
                    pw.SizedBox(width: 10),
                    pw.Expanded(child: _buildLabel(record, qrCodeImage)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Expanded(child: _buildLabel(record, qrCodeImage)),
                    pw.SizedBox(width: 10),
                    pw.Expanded(child: _buildLabel(record, qrCodeImage)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return document.save();
  }

  pw.Widget _buildLabel(PlantRecord record, pw.ImageProvider? qrCodeImage) {
    final collectionNumber = _resolveCollectionNumber(record);
    final locality = _buildLocality(record);
    final coordinates = _buildCoordinates(record);
    final morphology = _buildMorphology(record);

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey700, width: 0.8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      strings.appTitle.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      strings.title,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey700, width: 0.6),
                ),
                child: pw.Text(
                  collectionNumber,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Container(height: 0.6, color: PdfColors.grey400),
          pw.SizedBox(height: 8),
          pw.Text(
            (record.family ?? strings.notSpecified).toUpperCase(),
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            record.scientificName,
            maxLines: 2,
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
          pw.SizedBox(height: 8),
          _field(strings.family, record.family),
          _field(strings.collector, record.contributorName),
          _field(strings.collectionDate, _formatDate(record.dateCollected)),
          _field(strings.locality, locality, maxLines: 3),
          _field(strings.gpsCoordinates, coordinates),
          _field(strings.altitude, _formatAltitude(record.altitude)),
          _field(strings.habitat, record.habitat, maxLines: 3),
          pw.SizedBox(height: 6),
          pw.Text(
            strings.morphologicalNotes,
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Expanded(
            child: pw.Text(
              morphology,
              maxLines: 8,
              style: const pw.TextStyle(fontSize: 7.5, height: 1.25),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Align(
            alignment: pw.Alignment.bottomRight,
            child: qrCodeImage == null
                ? pw.SizedBox(width: 58, height: 58)
                : pw.Container(
                    width: 58,
                    height: 58,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColors.grey400,
                        width: 0.5,
                      ),
                    ),
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Image(qrCodeImage, fit: pw.BoxFit.contain),
                  ),
          ),
        ],
      ),
    );
  }

  pw.Widget _field(String label, String? value, {int maxLines = 2}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.RichText(
        maxLines: maxLines,
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 8, height: 1.25),
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: _sanitize(value)),
          ],
        ),
      ),
    );
  }

  String _resolveCollectionNumber(PlantRecord record) {
    final registry = record.registryIdentifier?.trim();
    if (registry != null && registry.isNotEmpty) {
      return registry;
    }

    final collectorNumber = record.collectorNumber?.trim();
    if (collectorNumber != null && collectorNumber.isNotEmpty) {
      return collectorNumber;
    }

    return record.uuid.substring(0, 8).toUpperCase();
  }

  String _buildLocality(PlantRecord record) {
    final parts = <String>[
      if (_hasText(record.locality)) record.locality!,
      if (_hasText(record.municipality)) record.municipality!,
      if (_hasText(record.state)) record.state!,
      if (_hasText(record.country)) record.country!,
      if (_hasText(record.session.value?.location)) record.session.value!.location!,
      if (_hasText(record.vegetationType)) record.vegetationType!,
      if (_hasText(record.topography)) record.topography!,
    ];

    return parts.isEmpty ? strings.notSpecified : parts.join(' • ');
  }

  String _buildCoordinates(PlantRecord record) {
    if (record.latitude == null || record.longitude == null) {
      return strings.notSpecified;
    }

    final latitude = record.latitude!;
    final longitude = record.longitude!;

    final latHemisphere = latitude >= 0 ? 'N' : 'S';
    final lonHemisphere = longitude >= 0 ? 'E' : 'W';

    return '${latitude.abs().toStringAsFixed(6)}°$latHemisphere, '
        '${longitude.abs().toStringAsFixed(6)}°$lonHemisphere';
  }

  String _formatAltitude(double? altitude) {
    if (altitude == null) {
      return strings.notSpecified;
    }

    return '${altitude.toStringAsFixed(0)} m';
  }

  String _buildMorphology(PlantRecord record) {
    final sections = <String>[];

    void addSection(String label, String? value) {
      if (_hasText(value)) {
        sections.add('$label: ${_sanitize(value)}');
      }
    }

    addSection(strings.root, record.raiz);
    addSection(strings.stem, record.caule);
    addSection(strings.leaf, record.folhaDescricao);
    addSection(strings.flower, record.florDescricao);
    addSection(strings.fruit, record.frutoDescricao);
    addSection(strings.seed, record.sementeDescricao);
    addSection(strings.notes, record.notes);

    return sections.isEmpty ? strings.notSpecified : sections.join(' • ');
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _sanitize(String? value) {
    final normalized = value?.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized == null || normalized.isEmpty) {
      return strings.notSpecified;
    }

    return normalized;
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  Future<Uint8List?> _buildQrCode(String data) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
      eyeStyle: const QrEyeStyle(color: ui.Color(0xFF000000)),
      dataModuleStyle: const QrDataModuleStyle(color: ui.Color(0xFF000000)),
    );

    final imageData = await painter.toImageData(
      256,
      format: ui.ImageByteFormat.png,
    );

    return imageData?.buffer.asUint8List();
  }
}
