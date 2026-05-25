import 'package:isar/isar.dart';

part 'label_template.g.dart';

/// Paper size + cut for herbarium labels.
enum LabelPaperSize {
  a4,
  letter,
  thermal80mm,
}

/// Reusable layout/content template for herbarium specimen labels.
///
/// Built-in templates are shipped with the app and cannot be deleted; users may
/// create custom templates per institution. Templates are local-only for now —
/// add a [SyncMetadata] embedded later when multi-device sharing is needed.
@collection
class LabelTemplate {
  Id id = Isar.autoIncrement;

  /// Stable identifier for built-in templates and future sync.
  @Index(unique: true, replace: true)
  late String uuid;

  late String name;

  /// Free-text institution name printed on the label header (optional).
  String? institutionName;

  @enumerated
  late LabelPaperSize paperSize;

  /// Number of labels per printed page. Must be >= 1.
  /// Common values: A4 → 1, 2, 4, 8; thermal → 1.
  late int labelsPerPage;

  // ── Field toggles ──
  late bool showQrCode;
  late bool showFamily;
  late bool showCollector;
  late bool showCollectionDate;
  late bool showLocality;
  late bool showCoordinates;
  late bool showAltitude;
  late bool showHabitat;
  late bool showMorphology;
  late bool showNotes;

  /// Built-in templates ship with the app and cannot be deleted/renamed.
  late bool isBuiltIn;

  late DateTime createdAt;
  late DateTime updatedAt;

  LabelTemplate();

  /// Defaults that mirror the original [HerbariumLabelService] output:
  /// A4, 4 labels per page, all fields visible, QR enabled.
  factory LabelTemplate.standard({required String uuid, required String name}) {
    final now = DateTime.now();
    return LabelTemplate()
      ..uuid = uuid
      ..name = name
      ..paperSize = LabelPaperSize.a4
      ..labelsPerPage = 4
      ..showQrCode = true
      ..showFamily = true
      ..showCollector = true
      ..showCollectionDate = true
      ..showLocality = true
      ..showCoordinates = true
      ..showAltitude = true
      ..showHabitat = true
      ..showMorphology = true
      ..showNotes = true
      ..isBuiltIn = true
      ..createdAt = now
      ..updatedAt = now;
  }

  /// Compact template: 8 labels per A4 page, no morphology block.
  factory LabelTemplate.compact({required String uuid, required String name}) {
    final now = DateTime.now();
    return LabelTemplate()
      ..uuid = uuid
      ..name = name
      ..paperSize = LabelPaperSize.a4
      ..labelsPerPage = 8
      ..showQrCode = true
      ..showFamily = true
      ..showCollector = true
      ..showCollectionDate = true
      ..showLocality = true
      ..showCoordinates = true
      ..showAltitude = false
      ..showHabitat = false
      ..showMorphology = false
      ..showNotes = false
      ..isBuiltIn = true
      ..createdAt = now
      ..updatedAt = now;
  }

  /// Single full-page label (one record per page) — useful for type specimens
  /// or featured collections.
  factory LabelTemplate.large({required String uuid, required String name}) {
    final now = DateTime.now();
    return LabelTemplate()
      ..uuid = uuid
      ..name = name
      ..paperSize = LabelPaperSize.a4
      ..labelsPerPage = 1
      ..showQrCode = true
      ..showFamily = true
      ..showCollector = true
      ..showCollectionDate = true
      ..showLocality = true
      ..showCoordinates = true
      ..showAltitude = true
      ..showHabitat = true
      ..showMorphology = true
      ..showNotes = true
      ..isBuiltIn = true
      ..createdAt = now
      ..updatedAt = now;
  }
}

/// Stable UUIDs for the built-in templates. Used to seed the database
/// idempotently on app start.
class BuiltInLabelTemplates {
  static const String standardUuid = '00000000-0000-4000-8000-000000000001';
  static const String compactUuid = '00000000-0000-4000-8000-000000000002';
  static const String largeUuid = '00000000-0000-4000-8000-000000000003';

  static const List<String> allUuids = [
    standardUuid,
    compactUuid,
    largeUuid,
  ];

  const BuiltInLabelTemplates._();
}
