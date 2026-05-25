import 'package:flutter_test/flutter_test.dart';

import 'package:field_book/core/services/herbarium_label_service.dart';
import 'package:field_book/models/label_template.dart';
import 'package:field_book/models/plant_record.dart';

HerbariumLabelStrings _strings() => HerbariumLabelStrings(
      appTitle: 'Field Book',
      title: 'Herbarium label',
      family: 'Family',
      collector: 'Collector',
      collectionDate: 'Date',
      locality: 'Locality',
      gpsCoordinates: 'GPS',
      altitude: 'Altitude',
      habitat: 'Habitat',
      morphologicalNotes: 'Morphology',
      notes: 'Notes',
      root: 'Root',
      stem: 'Stem',
      leaf: 'Leaf',
      flower: 'Flower',
      fruit: 'Fruit',
      seed: 'Seed',
      notSpecified: 'Not specified',
    );

PlantRecord _record(String uuid) => PlantRecord()
  ..uuid = uuid
  ..scientificName = 'Cecropia pachystachya'
  ..family = 'Urticaceae'
  ..contributorName = 'R. Cardim'
  ..dateCollected = DateTime(2026, 5, 12)
  ..locality = 'PARNA Itatiaia'
  ..habitat = 'Mata úmida';

void main() {
  group('HerbariumLabelService – grid resolution', () {
    test('supports 1, 2, 4, 8 labels per page', () {
      expect(HerbariumLabelService.debugResolveGrid(1).capacity, 1);
      expect(HerbariumLabelService.debugResolveGrid(2).capacity, 2);
      expect(HerbariumLabelService.debugResolveGrid(4).capacity, 4);
      expect(HerbariumLabelService.debugResolveGrid(8).capacity, 8);
    });

    test('rejects unsupported labelsPerPage', () {
      expect(
        () => HerbariumLabelService.debugResolveGrid(3),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => HerbariumLabelService.debugResolveGrid(0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('HerbariumLabelService – batch generation', () {
    test('throws on empty record list', () async {
      final service = HerbariumLabelService(strings: _strings());
      final template = LabelTemplate.standard(
        uuid: BuiltInLabelTemplates.standardUuid,
        name: 'Standard',
      );
      expect(
        () => service.generateLabels(const [], template),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('produces a non-empty PDF for a single record', () async {
      final service = HerbariumLabelService(strings: _strings());
      final template = LabelTemplate.standard(
        uuid: BuiltInLabelTemplates.standardUuid,
        name: 'Standard',
      );
      final bytes = await service.generateLabels(
        [_record('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')],
        template,
      );
      expect(bytes.length, greaterThan(1000));
      // PDF magic bytes: %PDF
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('compact template (8/page) chunks 9 records into 2 pages', () async {
      final service = HerbariumLabelService(strings: _strings());
      final template = LabelTemplate.compact(
        uuid: BuiltInLabelTemplates.compactUuid,
        name: 'Compact',
      );
      final records = List.generate(
        9,
        (i) => _record('11111111-1111-4111-8111-${i.toString().padLeft(12, '0')}'),
      );
      final bytes = await service.generateLabels(records, template);
      expect(bytes.length, greaterThan(1000));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });
}
