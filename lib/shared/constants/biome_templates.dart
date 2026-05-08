import '../../core/utils/biome_detector.dart';

class BuiltInCollectionTemplateSeed {
  final String uuid;
  final String name;
  final String biome;
  final bool isBuiltIn;
  final String? habitatTemplate;
  final String? vegetationTypeTemplate;
  final String? topographyTemplate;
  final String? substrateTemplate;
  final String? notesTemplate;

  const BuiltInCollectionTemplateSeed({
    required this.uuid,
    required this.name,
    required this.biome,
    this.isBuiltIn = true,
    this.habitatTemplate,
    this.vegetationTypeTemplate,
    this.topographyTemplate,
    this.substrateTemplate,
    this.notesTemplate,
  });
}

const builtInBiomeTemplates = <BuiltInCollectionTemplateSeed>[
  BuiltInCollectionTemplateSeed(
    uuid: 'builtin-template-cerrado',
    name: 'Cerrado',
    biome: BiomeDetector.cerrado,
    habitatTemplate:
        'Área savânica aberta, com alta incidência solar e sazonalidade marcada.',
    vegetationTypeTemplate: 'Cerrado sensu stricto',
    topographyTemplate: 'Chapada suave ou interflúvio bem drenado',
    substrateTemplate:
        'Solo ácido, arenoso a argiloso, com cascalho laterítico',
    notesTemplate:
        'Registrar indícios de fogo, casca espessa, xilopódio e espécies associadas do estrato herbáceo-arbustivo.',
  ),
  BuiltInCollectionTemplateSeed(
    uuid: 'builtin-template-mata-atlantica',
    name: 'Mata Atlântica',
    biome: BiomeDetector.mataAtlantica,
    habitatTemplate:
        'Fragmento florestal úmido, com sombreamento intenso e serapilheira abundante.',
    vegetationTypeTemplate: 'Mata Atlântica',
    topographyTemplate: 'Encosta, vale úmido ou borda de floresta',
    substrateTemplate: 'Solo rico em matéria orgânica e húmus',
    notesTemplate:
        'Anotar estratificação da mata, presença de epífitas, lianas e proximidade de cursos d’água.',
  ),
  BuiltInCollectionTemplateSeed(
    uuid: 'builtin-template-amazonia',
    name: 'Amazônia',
    biome: BiomeDetector.amazonia,
    habitatTemplate:
        'Floresta densa de terra firme ou ambiente sazonalmente inundável.',
    vegetationTypeTemplate: 'Floresta Amazônica',
    topographyTemplate: 'Terra firme, baixio ou margem de igarapé',
    substrateTemplate:
        'Solo argiloso ou arenoso úmido, com camada orgânica superficial',
    notesTemplate:
        'Descrever dossel, umidade, presença de palmeiras, cipós e sinais de inundação.',
  ),
  BuiltInCollectionTemplateSeed(
    uuid: 'builtin-template-caatinga',
    name: 'Caatinga',
    biome: BiomeDetector.caatinga,
    habitatTemplate:
        'Ambiente semiárido com vegetação aberta e forte estresse hídrico sazonal.',
    vegetationTypeTemplate: 'Caatinga arbustivo-arbórea',
    topographyTemplate: 'Pediplano, lajedo ou depressão sertaneja',
    substrateTemplate: 'Solo raso, pedregoso ou arenoso, com afloramentos rochosos',
    notesTemplate:
        'Registrar deciduidade, suculência, presença de espinhos e sinais recentes de chuva.',
  ),
  BuiltInCollectionTemplateSeed(
    uuid: 'builtin-template-pampa',
    name: 'Pampa',
    biome: BiomeDetector.pampa,
    habitatTemplate:
        'Campo aberto com domínio herbáceo e influência de ventos constantes.',
    vegetationTypeTemplate: 'Campo sulino',
    topographyTemplate: 'Coxilha, baixada ou campo plano ondulado',
    substrateTemplate: 'Solo profundo, arenoso a argiloso, com drenagem variável',
    notesTemplate:
        'Anotar cobertura graminoide, pressão de pastejo, umidade do campo e espécies acompanhantes.',
  ),
  BuiltInCollectionTemplateSeed(
    uuid: 'builtin-template-pantanal',
    name: 'Pantanal',
    biome: BiomeDetector.pantanal,
    habitatTemplate:
        'Planície sazonalmente inundável com mosaico de campos, capões e áreas alagadas.',
    vegetationTypeTemplate: 'Pantanal',
    topographyTemplate: 'Baixada alagável, cordilheira ou borda de baía',
    substrateTemplate:
        'Solo hidromórfico, lodoso ou arenoso, sujeito a pulsos de inundação',
    notesTemplate:
        'Registrar nível d’água, marcas de cheia, presença de macrófitas e influência do pulso de inundação.',
  ),
];
