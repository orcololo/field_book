# Folium 🌿

**Aplicativo de Coleta e Documentação Botânica de Campo**

Folium (_latim para "folha"_) é um aplicativo mobile offline-first para documentação de coletas botânicas de campo. Ele transforma seu celular em um caderno de campo digital completo — com GPS, câmera, notas de áudio, identificação de espécies e exportação de dados científicos.

[![Release](https://img.shields.io/github/v/release/orcololo/field_book?include_prereleases)](https://github.com/orcololo/field_book/releases/latest)
![Plataforma](https://img.shields.io/badge/plataforma-Android-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.38.9-blue)
![Licença](https://img.shields.io/badge/licença-TBD-lightgrey)

---

## Download

Baixe o APK mais recente em [GitHub Releases](https://github.com/orcololo/field_book/releases/latest).

Três APKs específicos por arquitetura estão disponíveis:

| APK | Dispositivo |
|-----|-------------|
| `folium-*-arm64-v8a.apk` | Celulares modernos (recomendado) |
| `folium-*-armeabi-v7a.apk` | Dispositivos ARM 32-bit mais antigos |
| `folium-*-x86_64.apk` | Emuladores e dispositivos x86 |

### Requisitos

- Android 5.0 (API 21) ou superior
- ~85 MB de armazenamento livre
- Permissões de GPS, câmera e microfone (solicitadas no uso)

### Instalação

Transfira o APK para o dispositivo e abra-o, ou via ADB:

```bash
adb install folium-<versao>-arm64-v8a.apk
```

---

## Funcionalidades

### Documentação de Plantas
- Nomes científicos com validação de nomenclatura binomial
- Medições dinâmicas (entradas ilimitadas por planta)
- Galeria de fotos com extração de metadados EXIF
- Notas de áudio com transcrição Whisper on-device
- Coordenadas GPS com posicionamento interativo no mapa
- Sistema de rascunhos para registros incompletos
- Identificadores de registro auto-gerados (ex: `RC000042`)

### Sessões de Coleta
- Agrupe plantas por saídas de campo
- Membros da equipe, localização, período, notas
- Compartilhe sessões via códigos de 6 caracteres
- Arquive sessões concluídas

### Mapas e Localização
- Mapa interativo OpenStreetMap com marcadores coloridos por categoria
- Busca por raio GPS com otimização bounding-box
- Download de tiles offline para campo sem internet
- Provedores configuráveis (OSM, Mapbox Streets, Mapbox Satellite)

### Identificação de Espécies
- Chave dicotômica para identificação taxonômica
- Identificação por imagem via PlantNet
- Integração com iNaturalist
- OCR para digitalização de etiquetas de herbário

### Exportação e Backup
- **JSON** — formato completo com todos os dados
- **CSV** — compatível com planilhas
- **Darwin Core** — padrão internacional de biodiversidade (GBIF/iNaturalist)
- **PDF** — relatório visual com fotos e detalhes
- Backup na nuvem via Google Drive
- Importação com estratégia de merge por UUID

### Estatísticas e Análises
- Cards de visão geral da coleção
- Distribuição por categoria (gráfico de pizza)
- Tendências mensais de coleta (gráfico de barras)
- Feed de atividade recente

### Captura Rápida
- Entrada com um toque: GPS + câmera + identificador automático
- Modo chuva para condições adversas de campo

### Internacionalização
- Português (BR), Inglês, Espanhol

---

## Desenvolvimento

### Pré-requisitos

- Flutter SDK 3.38.9+
- Dart SDK 3.10.8+
- Android SDK (API 21–36)
- Java 17

### Setup

```bash
git clone https://github.com/orcololo/field_book.git
cd field_book
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Build de Release

```bash
flutter build apk --split-per-abi --release
```

### Qualidade de Código

```bash
flutter analyze
dart format lib/
flutter test
```

---

## CI/CD

Releases são automatizadas via GitHub Actions. Faça push de uma tag para disparar o pipeline:

```bash
git tag v1.9.0
git push origin v1.9.0
```

O workflow builda APKs split por arquitetura, faz upload como artifacts e cria uma GitHub Release com notas automáticas.

---

## Arquitetura

- **Gerenciamento de Estado**: Riverpod com code generation
- **Banco de Dados**: Isar (NoSQL embarcado, offline-first)
- **Rede**: Dio com interceptor de auth e conectividade
- **Mapas**: flutter_map + OpenStreetMap
- **Áudio**: Whisper ML (on-device) + SpeechToText
- **Design**: Material 3 com tema eco-moderno (Forest Green, Earth Brown, Sky Blue)

### Estrutura do Projeto

```
lib/
├── core/           # Infraestrutura (rede, banco, serviços, tema, sync)
├── features/       # 16 módulos de funcionalidades (auth, map, plant_form, sessions, etc.)
├── models/         # 15 modelos de dados Isar
├── shared/         # Widgets e utilitários reutilizáveis
└── l10n/           # Localização (pt, en, es)
```

---

## Contribuindo

1. Fork o repositório
2. Crie uma branch de feature (`git checkout -b feature/minha-feature`)
3. Commit suas mudanças
4. Push para a branch (`git push origin feature/minha-feature`)
5. Abra um Pull Request

---

## Licença

TBD
