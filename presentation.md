---
marp: true
theme: default
paginate: true
backgroundColor: #FAFAFA
color: #1C1B1F
style: |
  :root {
    --color-primary: #3D7A52;
    --color-primary-dark: #234A30;
    --color-secondary: #6D4C41;
    --color-tertiary: #0288D1;
    --color-surface: #221717;
    --color-on-surface: #1C1B1F;
  }
  section {
    font-family: 'Segoe UI', Roboto, sans-serif;
  }
  h1, h2, h3 {
    color: var(--color-primary);
  }
  h1 {
    font-size: 2.2em;
  }
  a {
    color: var(--color-tertiary);
  }
  strong {
    color: var(--color-primary-dark);
  }
  em {
    color: var(--color-secondary);
  }
  code {
    background: #E8F5E9;
    color: var(--color-primary-dark);
    padding: 2px 8px;
    border-radius: 4px;
  }
  section.lead {
    background: linear-gradient(135deg, #234A30 0%, #3D7A52 50%, #2D5F3F 100%);
    color: #221717;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  section.lead h1, section.lead h2, section.lead h3 {
    color: #221717;
  }
  section.lead em {
    color: #A5D6A7;
  }
  section.invert {
    background: #234A30;
    color: white;
  }
  section.invert h1, section.invert h2, section.invert h3 {
    color: #A5D6A7;
  }
  table {
    font-size: 0.85em;
  }
  th {
    background: #3D7A52;
    color: white;
  }
  td {
    border-color: #E8F5E9;
  }
  blockquote {
    border-left: 4px solid #3D7A52;
    background: #E8F5E9;
    padding: 12px 20px;
    border-radius: 0 8px 8px 0;
    color: #234A30;
  }
  ul li::marker {
    color: #3D7A52;
  }
  footer {
    color: #757575;
    font-size: 0.7em;
  }
---

<!-- _class: lead -->

# 🌿 Folium

### Caderneta de Campo Digital para Botânica

_Do latim "folium" — folha_

**v1.8.0 · Flutter · Android · Offline-first**

---

# O Problema

## Desafios na pesquisa botânica de campo

- 📋 Cadernetas em **papel** são frágeis e difíceis de organizar
- 📍 Registrar **coordenadas GPS** manualmente é propenso a erros
- 📸 **Fotos** ficam separadas das anotações do espécime
- 🔍 **Buscar** um registro entre centenas de fichas é lento

---

# O Problema

## Mais desafios...

- 📤 **Exportar** dados para planilhas ou herbários requer retrabalho manual
- 🌐 Pesquisa de campo acontece em áreas **sem conexão à internet**
- 🏷️ **Identificadores** são controlados em planilhas externas sem validação

> _Pesquisadores perdem tempo valioso com burocracia e correm risco de perder dados insubstituíveis._

---

# A Solução

## Folium — Caderneta de Campo Digital

Um aplicativo móvel moderno e intuitivo que **digitaliza e organiza** todo o fluxo de coleta botânica — do campo ao herbário.

🌱 **Registro completo** — taxonomia, medições, habitat, notas
📍 **GPS automático** — captura com um toque + mapa interativo
📸 **Galeria de fotos** — câmera/galeria + metadados EXIF

---

# A Solução

## Mais recursos do Folium

🎙️ **Notas de áudio** — gravação + transcrição IA (Whisper on-device)
📦 **Exportação científica** — JSON, CSV e **Darwin Core** (GBIF)
☁️ **Backup na nuvem** — Google Drive com restauração
🔒 **100% offline-first** — banco local Isar, mapas offline, ML local

---

# Funcionalidades

## 🌱 Registro de Plantas — Formulário em 6 Abas (1/2)

| Aba                     | Campos                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------- |
| **Informações Básicas** | Nome científico (validação binomial), nome popular, família (auto-sugerida), gênero, espécie, categoria |
| **Localização**         | GPS automático + mapa interativo para posicionar manualmente                                            |
| **Habitat**             | Descrição textual do ambiente de coleta                                                                 |

---

# Funcionalidades

## 🌱 Registro de Plantas — Formulário em 6 Abas (2/2)

| Aba          | Campos                                                                 |
| ------------ | ---------------------------------------------------------------------- |
| **Medições** | Lista dinâmica: rótulo + valor + unidade (ilimitadas)                  |
| **Fotos**    | Câmera ou galeria (seleção múltipla), compressão JPEG, miniaturas      |
| **Áudio**    | Gravação com qualidade configurável (64–192 kbps), transcrição Whisper |

Salve como **rascunho** ou **completo**. Identificador gerado automaticamente.

---

# Funcionalidades

## 🧬 Inteligência Botânica

- **Validação de nomenclatura binomial** — verifica formato _Gênero espécie_
- **Auto-sugestão de família** a partir do gênero
  - 15 famílias e 50+ gêneros mapeados
  - _Ex.:_ digitar _Eucalyptus_ → sugere **Myrtaceae**
- **Detecção de duplicatas** em tempo real com debounce
- **8 categorias** de plantas: árvores, arbustos, ervas, samambaias, gramíneas, trepadeiras, cactos, aquáticas

---

# Funcionalidades

## 🏷️ Sistema de Identificadores

- Formato: `{Iniciais}{6 dígitos}` → ex.: `RC000042`
- Geração **thread-safe** dentro de transação Isar (sem duplicatas)
- Resolução de colisões (até 100 tentativas)
- Iniciais configuráveis (1–4 letras maiúsculas)
- Validação por regex: `^[A-Z]{1,4}\d{1,6}$`
- Atribuição em massa com preview antes de confirmar

---

# Funcionalidades

## 🔍 Busca Avançada

- **Dois modos de busca:**
  - 🔤 Por **nome** (busca full-text em campos indexados, lowercase)
  - 🏷️ Por **identificador** (correspondência exata + prefixo)
- **Filtros combináveis:** categoria + status (rascunho/completo) + período de datas
- **Resultados instantâneos** (busca indexada < 100ms, a partir de 2 caracteres)
- **Buscas salvas** — persista consultas e filtros para reuso rápido

---

# Funcionalidades

## 📋 Sessões de Coleta

- Agrupe plantas por **expedição de campo**
- Campos: nome da viagem, local, datas, **equipe** (lista dinâmica), notas
- **Código de compartilhamento** de 6 caracteres (único) para multi-dispositivo
- **Arquivamento** de sessões finalizadas (sem perder dados)
- Exclusão bloqueada se houver plantas associadas (integridade referencial)

---

# Funcionalidades

## 🗺️ Mapas e Localização

- **Mapa interativo** em tela cheia com OpenStreetMap
- **Marcadores coloridos** por categoria de planta (com legenda)
- **Busca por raio GPS** — pré-filtragem por bounding box + distância Haversine
- **Download de mapas offline** — selecione uma região, baixe os tiles
- Estatísticas de cache (qtd. tiles, tamanho em MB)
- **3 provedores**: OpenStreetMap, Mapbox Streets, Mapbox Satellite

---

# Funcionalidades

## 📸 Galeria de Fotos

- **Grade global** de fotos de todas as plantas — ordenável por data ou nome
- **Visualizador fullscreen** — zoom, pan, deslizar entre fotos
- **Overlay com dados EXIF:** câmera, ISO, abertura, velocidade, resolução
- Exibe nome científico, coordenadas GPS e data da foto
- **Filtros** por categoria de planta e período

---

# Funcionalidades

## 📊 Estatísticas e Análises

- **Cards resumo:** total de plantas, sessões, rascunhos, coletas do mês
- **Gráfico de pizza** — distribuição por categoria
- **Gráfico de barras** — coletas por mês (últimos 6 meses)
- **Atividade recente** — últimas 5 plantas coletadas

---

# Funcionalidades

## 🎙️ Áudio & Transcrição com IA

- **Gravação** com controles completos: iniciar, pausar, retomar, parar, cancelar
- **3 níveis de qualidade:** baixa (64 kbps), média (128 kbps), alta (192 kbps) — AAC
- **Transcrição dual:**
  - 🤖 **Whisper ML** (on-device) — funciona **sem internet**
  - 🎤 **SpeechToText** — entrada de voz em tempo real
- Notas de áudio vinculadas ao registro com reprodução integrada

---

# Funcionalidades

## 🗂️ Exportação de Dados

| Formato         | Detalhes                                                         |
| --------------- | ---------------------------------------------------------------- |
| **JSON**        | Exportação completa com todos os campos + sessões                |
| **CSV**         | Exportação tabular com cabeçalhos em português                   |
| **Darwin Core** | Padrão internacional — compatível com **GBIF** e **iNaturalist** |

Compartilhamento via **share sheet** do sistema.

---

# Funcionalidades

## 🗂️ Importação de Dados

- **Importação JSON** com merge por UUID (atualiza existentes, cria novos)
- **Exportação de identificadores** em JSON, CSV e **Excel (XLSX)**
- **Importação de identificadores** com sanitização de células
  - Proteção contra injeção de fórmulas
- Resultado detalhado: importados / atualizados / ignorados / erros

---

# Funcionalidades

## ☁️ Backup na Nuvem

- Login via **Google Sign-In** → API do Google Drive
- Backup no `appDataFolder` (oculto para o usuário)
- Restauração com merge de dados existentes
- Opção **somente WiFi**
- Timestamp do último backup

---

# Funcionalidades

## ⚙️ Configurações Completas

- **Idioma:** Português (padrão), Inglês, Espanhol
  - ~130 chaves localizadas
- **Identificadores:** iniciais, número, auto-gerar, gerenciamento em massa
- **Mapas:** provedor, raio de cache (1–50 km), auto-cache

---

# Funcionalidades

## ⚙️ Mais Configurações

- **Fotos:** compressão (30–100), preservar EXIF
- **Áudio:** transcrição on/off, locale, qualidade
- **Performance:** tamanho de paginação, cache de miniaturas
- **Sobre:** versão do app, device ID, exibir tutorial

---

# Funcionalidades

## 🎓 Onboarding Guiado

Tutorial de **5 páginas** interativas na primeira abertura do app:

1. 🌿 **Bem-vindo ao Folium** — apresentação
2. 📋 **Sessões de Coleta** — como organizar expedições
3. 🌱 **Registro de Plantas** — fotos, GPS, áudio, transcrição
4. 📤 **Exportar e Compartilhar** — JSON, CSV, Darwin Core
5. ⚙️ **Configuração Inicial** — iniciais e número do identificador

> Pode ser re-acessado em **Configurações → Exibir Tutorial**

---

<!-- _class: invert -->

# Design

## Eco-Moderno: _"Natureza encontra tecnologia"_

Paleta de cores inspirada na **natureza**, com tons de terra e verde floresta.

🟢 **Verde Primário** `#3D7A52` — Folha
🟤 **Marrom Secundário** `#6D4C41` — Solo
🔵 **Azul Terciário** `#0288D1` — Água

---

# Design

## Paleta de Cores Completa

🟢 Verde Escuro `#234A30` — Floresta
🟤 Marrom Claro `#8D6E63` — Argila
🔵 Azul Claro `#4FC3F7` — Céu

✅ Sucesso `#4CAF50` · ⚠️ Alerta `#FF9800`
❌ Erro `#E53935` · ℹ️ Info `#2196F3`

**Suporte a tema claro e escuro** · Material Design 3

---

# Design

## Componentes Visuais (1/2)

| Componente         | Função                                              |
| ------------------ | --------------------------------------------------- |
| `ModernPlantCard`  | Card com imagem 16:9, badges, indicadores GPS/fotos |
| `GlassAppBar`      | App bar com efeito de vidro fosco (backdrop blur)   |
| `ModernSearchBar`  | Campo de busca com botão de limpar                  |
| `EmptyStateWidget` | Estados vazios contextuais com ilustrações          |

---

# Design

## Componentes Visuais (2/2)

| Componente            | Função                                           |
| --------------------- | ------------------------------------------------ |
| `ShimmerLoading`      | Skeleton loading para cards e listas             |
| `AudioRecorderWidget` | Gravador com iniciar/pausar/retomar/parar        |
| `AudioPlayerWidget`   | Reprodução de notas de áudio gravadas            |
| `MapWidget`           | FlutterMap reutilizável com marcadores e seleção |

**Espaçamento:** 4–64px · **Bordas:** 8–999px · **Animações:** 150/300/500ms

---

# Telas do Aplicativo

## 16 Telas — Navegação Principal

```
                        ┌─────────────────┐
                        │  🎓 Onboarding   │
                        │  (5 páginas)     │
                        └────────┬────────┘
                                 ▼
┌──────────────────────────────────────────────────────────┐
│                    🏠 Home (5 abas)                      │
├──────────┬──────────┬──────────┬──────────┬──────────────┤
│ 🌿Plantas│ 📋Sessões│ 🗺️ Mapa  │ 📊 Stats │ ⚙️ Config    │
└──────────┴──────────┴──────────┴──────────┴──────────────┘
```

---

# Telas do Aplicativo

## 16 Telas — Telas Secundárias

```
🌿 Plantas           📋 Sessões          ⚙️ Configurações
├── Detalhe          ├── Detalhe          ├── Export/Import
├── Edição rápida    ├── Formulário       ├── Identificadores
├── Busca + filtros  └── Compartilhar     ├── Galeria de Fotos
└── Formulário                            │   └── Viewer + EXIF
    (6 abas)         🗺️ Mapa              └── Onboarding
                     └── Mapas Offline
```

---

# Arquitetura Técnica

## Stack Tecnológica (1/2)

| Categoria          | Tecnologia                           |
| ------------------ | ------------------------------------ |
| **Framework**      | Flutter 3.10.8                       |
| **Linguagem**      | Dart 3.10.8                          |
| **Estado**         | Riverpod 2.6.1 + Code Generation     |
| **Banco de Dados** | Isar 3.1.0 (NoSQL embutido, offline) |
| **UI**             | Material Design 3 (claro + escuro)   |
| **Mapas**          | flutter_map + FMTC + ObjectBox       |
| **GPS**            | geolocator + Haversine               |

---

# Arquitetura Técnica

## Stack Tecnológica (2/2)

| Categoria      | Tecnologia                                     |
| -------------- | ---------------------------------------------- |
| **Gráficos**   | fl_chart                                       |
| **Áudio/ML**   | record + audioplayers + Whisper + SpeechToText |
| **Cloud**      | googleapis + Google Sign-In                    |
| **Exportação** | excel, csv, JSON, Darwin Core                  |
| **QR Code**    | qr_flutter + mobile_scanner                    |
| **i18n**       | intl (pt, en, es)                              |

---

# Arquitetura Técnica

## Estrutura Modular — Core

```
lib/
├── core/
│   ├── database/              # Isar (mobile/web split)
│   ├── repositories/ (3)     # PlantRepo, SessionRepo, SavedSearchRepo
│   ├── services/ (9)         # Audio, Export, Backup, Location,
│   │                         # Photo, Map, Registry,
│   │                         # IdentifierExport, Settings
│   ├── sync/                  # Infraestrutura de sync (planejado)
│   ├── theme/                 # FoliumTheme (759 linhas)
│   ├── errors/                # Tratamento de erros
│   └── utils/                 # BotanicalValidator, GeoUtils
```

---

# Arquitetura Técnica

## Estrutura Modular — Features & Models

```
├── features/ (12 módulos)
│   ├── onboarding/     ├── plant_form/
│   ├── plant_detail/   ├── plant_edit/
│   ├── home/           ├── search/
│   ├── sessions/       ├── map/
│   ├── photo_gallery/  ├── statistics/
│   ├── export_import/  └── settings/
├── models/ (8)
│   # PlantRecord, Session, Measurement, PhotoMetadata,
│   # SavedSearch, Settings, SyncMetadata, PlantCategory
├── shared/widgets/     # Modern, Audio, MapWidget
└── l10n/ (3 idiomas)  # pt, en, es
```

---

# Diferenciais

## Por que usar o Folium? (1/2)

| Método Tradicional (Papel)    | Folium                                   |
| ----------------------------- | ---------------------------------------- |
| ❌ Dados podem ser perdidos   | ✅ Banco local + backup Google Drive     |
| ❌ GPS anotado manualmente    | ✅ Captura GPS automática + mapa         |
| ❌ Fotos separadas das fichas | ✅ Galeria com EXIF integrada            |
| ❌ Busca lenta entre fichas   | ✅ Busca indexada em **< 100ms**         |
| ❌ Exportação manual          | ✅ 1 clique → CSV, JSON, **Darwin Core** |

---

# Diferenciais

## Por que usar o Folium? (2/2)

| Método Tradicional (Papel)                | Folium                                       |
| ----------------------------------------- | -------------------------------------------- |
| ❌ Depende de conexão                     | ✅ **100% offline-first** (banco, mapas, ML) |
| ❌ Sem padronização de identificadores    | ✅ Geração thread-safe com validação         |
| ❌ Observações de voz não são registradas | ✅ Áudio + transcrição IA on-device          |
| ❌ Sem validação taxonômica               | ✅ Nomenclatura binomial + auto-sugestão     |

---

# Público-Alvo

## Quem se beneficia com o Folium?

- 🎓 **Pesquisadores e botânicos** em trabalhos de campo
- 🌿 **Estudantes** de Biologia, Ciências Ambientais e Agronomia
- 🏛️ **Herbários** e coleções botânicas institucionais
- 🌍 **Projetos de conservação** e monitoramento ambiental
- 👩‍🔬 **Taxonomistas** que precisam de validação em campo
- 🌾 **Engenheiros florestais** em levantamentos de campo

---

# Roadmap

## Infraestrutura já presente no código

- 🔄 **Sincronização servidor** — modelo `SyncMetadata` já embutido em todos os registros
- 📱 **QR Code** para espécimes — dependências `qr_flutter` e `mobile_scanner` já incluídas
- ☁️ **Dropbox** como provedor de backup — opção já presente no enum de configurações

---

# Roadmap

## Próximos Passos

- 🍎 **Versão iOS** com design glassmórfico nativo
- 👥 **Colaboração em tempo real** entre pesquisadores
- 📊 **Relatórios customizados** e exportação em PDF
- 🏛️ **Integração com herbários digitais** — speciesLink, GBIF
- 🔬 **Identificação por IA** de espécies a partir de fotos

---

<!-- _class: lead -->

# 🌿 Folium

### Transformando a pesquisa botânica de campo

_Do registro à publicação — documentação moderna, organizada e acessível, mesmo sem internet._

**12 módulos · 16 telas · 9 serviços · 3 idiomas**
**v1.8.0 · Android · Flutter · Isar · Whisper ML**

_Obrigado!_
