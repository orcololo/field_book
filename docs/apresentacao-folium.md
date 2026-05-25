---
marp: true
theme: default
paginate: true
size: 16:9
title: Folium — Coleta Botânica de Campo
description: Apresentação do funcionamento do aplicativo Folium para botânicos e coletores
author: Equipe Folium
lang: pt-BR
style: |
  :root {
    --leaf-900: #0f2e1d;
    --leaf-700: #1b5e3a;
    --leaf-500: #2e8b57;
    --leaf-300: #8fd9a8;
    --leaf-50:  #f1f9f3;
    --bark:     #6b4423;
    --soil:     #3a2a1a;
    --sun:      #f4a23a;
    --paper:    #fbfaf5;
  }
  section {
    background: var(--paper);
    color: var(--soil);
    font-family: -apple-system, "Segoe UI", "Inter", sans-serif;
    padding: 60px 80px;
  }
  section.lead {
    background: linear-gradient(135deg, var(--leaf-900) 0%, var(--leaf-700) 60%, var(--leaf-500) 100%);
    color: var(--leaf-50);
    text-align: center;
    justify-content: center;
  }
  section.lead h1 { font-size: 84px; margin-bottom: 8px; letter-spacing: -2px; }
  section.lead h2 { font-size: 32px; font-weight: 400; color: var(--leaf-300); }
  section.section-cover {
    background: var(--leaf-700);
    color: var(--leaf-50);
    justify-content: center;
  }
  section.section-cover h1 { font-size: 72px; border: 0; }
  section.section-cover .step { font-size: 28px; color: var(--leaf-300); letter-spacing: 4px; text-transform: uppercase; }
  h1 { color: var(--leaf-900); border-bottom: 4px solid var(--leaf-500); padding-bottom: 12px; }
  h2 { color: var(--leaf-700); }
  h3 { color: var(--leaf-500); }
  strong { color: var(--leaf-700); }
  a { color: var(--leaf-500); }
  ul li::marker { color: var(--leaf-500); }
  blockquote {
    border-left: 6px solid var(--sun);
    background: #fff8ec;
    padding: 16px 24px;
    color: var(--soil);
    font-style: italic;
  }
  code { background: var(--leaf-50); color: var(--leaf-900); padding: 2px 6px; border-radius: 4px; }
  table { width: 100%; border-collapse: collapse; }
  th { background: var(--leaf-700); color: var(--leaf-50); padding: 10px; text-align: left; }
  td { padding: 10px; border-bottom: 1px solid var(--leaf-300); }
  .cols { display: grid; grid-template-columns: 1fr 1fr; gap: 32px; }
  .cols-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; }
  .card {
    background: var(--leaf-50);
    border-left: 6px solid var(--leaf-500);
    padding: 18px 22px;
    border-radius: 8px;
  }
  .card.warn { border-left-color: var(--sun); background: #fff8ec; }
  .card.bark { border-left-color: var(--bark); }
  .badge {
    display: inline-block;
    background: var(--leaf-500);
    color: white;
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 18px;
    font-weight: 600;
  }
  .phone {
    width: 280px;
    height: 540px;
    background: #1a1a1a;
    border-radius: 36px;
    padding: 14px;
    margin: 0 auto;
    box-shadow: 0 20px 60px rgba(0,0,0,0.25);
  }
  .phone-screen {
    width: 100%; height: 100%;
    background: var(--paper);
    border-radius: 24px;
    overflow: hidden;
    display: flex; flex-direction: column;
  }
  .phone-status {
    background: var(--leaf-700);
    color: var(--leaf-50);
    padding: 10px 16px;
    font-size: 14px;
    display: flex; justify-content: space-between;
  }
  .phone-body { padding: 16px; flex: 1; font-size: 14px; color: var(--soil); }
  .mock-card {
    background: white;
    border-radius: 12px;
    padding: 12px;
    margin-bottom: 10px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    border-left: 4px solid var(--leaf-500);
  }
  .mock-card .sci { font-style: italic; color: var(--leaf-700); font-weight: 600; }
  .mock-card .meta { color: #888; font-size: 12px; margin-top: 4px; }
  .flow-step {
    background: white;
    border: 2px solid var(--leaf-500);
    border-radius: 12px;
    padding: 14px;
    text-align: center;
  }
  .flow-arrow { font-size: 32px; color: var(--leaf-500); text-align: center; align-self: center; }
  .pill { display: inline-block; background: var(--leaf-300); color: var(--leaf-900); padding: 3px 10px; border-radius: 999px; font-size: 16px; margin: 2px; }
  footer { color: var(--leaf-700); font-weight: 500; }
---

<!-- _class: lead -->
<!-- _paginate: false -->

# 🌿 Folium

## Coleta botânica de campo, offline-first

**v1.9.0** · Para botânicos, herbários e coletores

---

<!-- _footer: 'Folium · Visão geral' -->

# Para quem é o Folium?

<div class="cols">

<div>

### 👩‍🔬 Botânicos & Pesquisadores
Registro de espécimes em expedições, com **GPS, fotos e áudio** mesmo sem sinal.

### 🌱 Coletores de campo
Captura rápida no momento da coleta — em segundos, não minutos.

### 🏛️ Curadores de herbário
Etiquetas padronizadas, exportação para CSV/Excel, integração com **iNaturalist**.

</div>

<div class="card">

**O problema que resolvemos**

> "Em campo, não há internet. Cadernos se molham. Planilhas no celular são lentas. Fotos perdem o GPS no caminho até o herbário."

Folium é **100% funcional offline** e sincroniza assim que você voltar à área coberta.

</div>

</div>

---

<!-- _class: section-cover -->

<div class="step">Parte 1</div>

# Primeiros passos

---

# 1. Login & primeiro acesso

<div class="cols">

<div>

### Como começar
1. Abra o app pela primeira vez
2. Veja o **tutorial guiado** (onboarding)
3. Faça login com **e-mail/senha** ou **Google**
4. Não tem conta? Cadastre-se direto no app

### Sem conexão?
- Login **lembra suas credenciais** e funciona offline
- Você só precisa de internet **uma vez** para o primeiro login
- Depois, todos os dados ficam no aparelho

</div>

<div class="phone">
<div class="phone-screen">
<div class="phone-status">🌿 Folium <span>9:41</span></div>
<div class="phone-body" style="display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;gap:14px;">
<div style="font-size:48px;">🌿</div>
<div style="font-size:18px;font-weight:600;color:var(--leaf-700);">Bem-vindo</div>
<div style="width:90%;background:#f0f0f0;border-radius:8px;padding:10px;text-align:left;">📧 voce@email.com</div>
<div style="width:90%;background:#f0f0f0;border-radius:8px;padding:10px;text-align:left;">🔒 ••••••••</div>
<div style="width:90%;background:var(--leaf-500);color:white;border-radius:8px;padding:12px;font-weight:600;">Entrar</div>
<div style="font-size:12px;color:#888;">ou continuar com Google</div>
</div>
</div>
</div>

</div>

---

# 2. Tela inicial: seu acervo

<div class="cols">

<div>

### O hub central
A **lista de plantas** é o coração do app:

- 🔍 **Busca rápida** por nome científico, popular, família
- 🏷️ **Filtros** por categoria (árvore, erva, samambaia…)
- ⚡ **Status de sincronização** visível em cada item
- ➕ **Botão flutuante** para nova coleta

### Indicadores de sincronização
- 🟢 sincronizado
- 🟡 pendente
- 🔴 conflito
- ⚪ apenas local

</div>

<div class="phone">
<div class="phone-screen">
<div class="phone-status">🌿 Acervo <span>📶 ⚡ 12 pend.</span></div>
<div class="phone-body">
<div style="background:#f0f0f0;border-radius:8px;padding:8px 12px;margin-bottom:10px;">🔍 Buscar planta…</div>
<div class="mock-card">
<div class="sci">Tibouchina granulosa</div>
<div style="font-size:13px;">Quaresmeira · Melastomataceae</div>
<div class="meta">📍 Manaus · 14/05 · 🟢</div>
</div>
<div class="mock-card">
<div class="sci">Caesalpinia ferrea</div>
<div style="font-size:13px;">Pau-ferro · Fabaceae</div>
<div class="meta">📍 RPPN Cristalino · 13/05 · 🟡</div>
</div>
<div class="mock-card">
<div class="sci">Dicksonia sellowiana</div>
<div style="font-size:13px;">Xaxim · Dicksoniaceae</div>
<div class="meta">📍 Itatiaia · 12/05 · 🟢</div>
</div>
</div>
</div>
</div>

</div>

---

<!-- _class: section-cover -->

<div class="step">Parte 2</div>

# Fluxo de coleta em campo

---

# 3. Sessão de coleta: o "diário do dia"

<div class="cols">

<div>

### Por que sessões?
Toda saída de campo vira uma **sessão** — agrupa todos os espécimes coletados naquela expedição.

### O que uma sessão contém
- 📅 **Data e horário** de início/fim
- 📍 **Localidade** + bioma detectado
- 👥 **Coletores e identificadores**
- 🌦️ **Clima** + 🌙 **fase da lua** automáticos
- 📝 **Notas livres** da expedição
- 🛣️ **Trilha GPS** opcional (registra o trajeto)

</div>

<div class="card">

### 💡 Dica
Crie a sessão **antes** de começar a coletar. Cada planta adicionada será automaticamente vinculada — você não precisa repetir localização, data e participantes em cada ficha.

</div>

<div class="card warn">

### ⚠️ Modo Chuva
Ativando o **modo chuva**, a interface fica com botões maiores e protege contra toques acidentais.

</div>

</div>

</div>

---

# 4. Captura rápida — a estrela do app

<div class="cols-3">

<div class="flow-step">
<div style="font-size:36px;">📸</div>
<strong>Foto</strong><br>
<small>1 toque<br>EXIF + GPS automáticos</small>
</div>

<div class="flow-arrow">→</div>

<div class="flow-step">
<div style="font-size:36px;">📍</div>
<strong>GPS</strong><br>
<small>Latitude, longitude,<br>altitude e precisão</small>
</div>

</div>

<br>

<div class="cols-3">

<div class="flow-step">
<div style="font-size:36px;">🎤</div>
<strong>Áudio</strong><br>
<small>Grave observações<br>de viva voz</small>
</div>

<div class="flow-arrow">→</div>

<div class="flow-step">
<div style="font-size:36px;">✅</div>
<strong>Salvo</strong><br>
<small>Tudo no aparelho,<br>sem internet</small>
</div>

</div>

<br>

> **Em ~10 segundos** você registra um espécime com foto georreferenciada, áudio com observações e tudo vinculado à sessão. Detalhar pode ficar para depois — no acampamento ou no laboratório.

---

# 5. Ficha completa do espécime

<div class="cols">

<div>

### Campos disponíveis
- **Identificação**
  - Número de coleta
  - Nome científico (com cache taxonômico)
  - Nome popular · Família
- **Morfologia & ecologia**
  - Categoria (árvore, erva, samambaia, epífita…)
  - Estado fenológico (flor, fruto, estéril…)
  - Método de coleta
  - Medidas (altura, DAP…)
- **Determinação**
  - Determinador, data, confiança
- **Mídia & localização**
  - Múltiplas fotos · áudios
  - Coordenadas + município (geocodificação reversa)

</div>

<div>

### 🤖 Apoios inteligentes
<div class="card">

**Reconhecimento por foto** (PlantNet)
Tire a foto, receba **sugestões de espécie** com porcentagem de confiança.

</div>

<div class="card">

**OCR** (etiquetas e cadernos)
Fotografe uma etiqueta antiga e o app **extrai o texto** automaticamente.

</div>

<div class="card">

**Transcrição de áudio** (on-device)
Suas notas faladas viram texto — sem enviar áudio para nuvem nenhuma.

</div>

<div class="card">

**Chave dicotômica interativa**
Avance passo a passo até identificar a espécie.

</div>

</div>

</div>

---

<!-- _class: section-cover -->

<div class="step">Parte 3</div>

# Mapa, identificação e busca

---

# 6. Mapa: enxergue suas coletas no território

<div class="cols">

<div>

### O que o mapa faz
- 🗺️ **Pinos** de todas as suas plantas no mapa
- 🛣️ **Trilhas GPS** sobrepostas
- 🔍 **Busca por raio** — "tudo o que coletei num raio de 500m daqui"
- 🧭 **Distâncias** calculadas via Haversine
- 🌎 **Bioma detectado** automaticamente

### 📥 Mapas offline
Antes de viajar, **baixe os tiles** da região:

1. Acesse *Mapas offline*
2. Selecione a área no mapa
3. Escolha o nível de zoom
4. Faça o download via Wi-Fi
5. Em campo, o mapa funciona **sem sinal**

</div>

<div class="phone">
<div class="phone-screen">
<div class="phone-status">🗺️ Mapa <span>📍 12 plantas</span></div>
<div class="phone-body" style="background:linear-gradient(135deg,#d4e8c8 0%,#8fd9a8 50%,#5fb478 100%);position:relative;padding:0;">
<div style="position:absolute;top:30%;left:25%;font-size:24px;">📍</div>
<div style="position:absolute;top:45%;left:55%;font-size:24px;">📍</div>
<div style="position:absolute;top:60%;left:35%;font-size:24px;">📍</div>
<div style="position:absolute;top:25%;left:65%;font-size:24px;">📍</div>
<div style="position:absolute;top:70%;left:70%;font-size:24px;">📍</div>
<div style="position:absolute;bottom:10px;left:10px;right:10px;background:white;border-radius:8px;padding:8px;font-size:12px;">
<strong>RPPN Cristalino</strong><br>12 espécimes no raio de 500m
</div>
</div>
</div>
</div>

</div>

---

# 7. Busca poderosa

<div class="cols">

<div>

### Tipos de busca
- **Texto livre** — nome científico, popular, família
- **Filtros combinados** — categoria + estado fenológico + intervalo de datas
- **Geoespacial** — dentro de um raio do GPS atual
- **Por coletor** — quem registrou
- **Salvas** — guarde filtros que você usa sempre

</div>

<div>

### Visualização
<div class="card">

📋 **Lista** com cards e fotos miniatura

</div>
<div class="card">

🖼️ **Galeria de fotos** — todas as imagens em mosaico

</div>
<div class="card">

📊 **Estatísticas** — gráficos por família, mês, bioma, fenologia

</div>

</div>

</div>

---

<!-- _class: section-cover -->

<div class="step">Parte 4</div>

# Sincronização & compartilhamento

---

# 8. Sincronização offline-first

<div class="cols">

<div>

### Como funciona
1. Você coleta **offline**, sem se preocupar
2. Tudo é salvo localmente no aparelho
3. Quando há internet, o app sincroniza **em segundo plano**
4. Conflitos são resolvidos por **última edição vence** — com revisão manual se necessário

### O que sincroniza
- ✅ Plantas, sessões, templates
- ✅ Fotos (com compressão automática)
- ✅ Áudios
- ✅ Identificadores e configurações

</div>

<div>

<div class="card">

### 🔄 Push / Pull
- **Push**: envia suas alterações locais
- **Pull**: traz mudanças feitas no servidor ou em outros dispositivos
- **Versionamento de protocolo** (F8) garante compatibilidade entre versões do app

</div>

<div class="card warn">

### ⚠️ Tela de conflitos
Quando duas pessoas editam o mesmo registro:
- Veja **lado a lado** as duas versões
- Escolha qual manter, ou combine campos
- Decisão fica registrada no histórico

</div>

</div>

</div>

---

# 9. Exportação, etiquetas e backup

<div class="cols">

<div>

### 📤 Exportar
- **CSV** — para Excel, R, pacotes estatísticos
- **JSON** — backup completo (fotos + áudios + tudo)
- **Excel** — planilha formatada
- **PDF** — fichas e relatórios prontos para imprimir

### 🏷️ Etiquetas de herbário *(novo na v1.9)*
- Geração de **etiquetas padronizadas** via PDF
- Inclui nome científico, coletor, número, data, localidade, GPS
- Pronto para colar na exsicata

</div>

<div>

### ☁️ Backup
<div class="card">

**Google Drive**
Backup completo automatizado direto para sua conta Drive — restaure em qualquer aparelho.

</div>

### 🌐 Integrações
<div class="card">

**iNaturalist**
Envie suas observações para a plataforma global de ciência cidadã com um toque.

</div>

<div class="card">

**Painel web** (frontend admin)
Curadores acessam o acervo pelo navegador para revisão e organização.

</div>

</div>

</div>

---

<!-- _class: section-cover -->

<div class="step">Parte 5</div>

# Recursos avançados

---

# 10. Ferramentas para o coletor experiente

<div class="cols">

<div>

### 📋 Templates de coleta
Salve combinações que você usa sempre:
*"Coleta de Bromeliaceae em Mata Atlântica"* já vem com categoria, método e família pré-preenchidos.

### 🔢 Identificadores
- Gere **números de coleta automáticos**
- Importe/exporte listas de identificadores
- Compartilhe sequências com sua equipe

### 📸 QR Code
Imprima QR codes nas exsicatas → escaneie para abrir o registro instantaneamente.

</div>

<div>

### 🌙 Dados ambientais automáticos
<div class="card">

**Clima** registrado no momento da coleta (OpenWeather)

</div>
<div class="card">

**Fase da lua** para estudos cronobiológicos

</div>
<div class="card">

**Bioma detectado** a partir das coordenadas

</div>

### 🌐 Idiomas
Português · Inglês · Espanhol

</div>

</div>

---

# 11. Privacidade e segurança

<div class="cols">

<div>

### Seus dados são seus
- 🔒 **Tokens armazenados** com criptografia do sistema (Keychain/Keystore)
- 📱 **Banco local** no seu aparelho — não na nuvem por padrão
- 🎤 **Transcrição de áudio on-device** — não vai para nenhum servidor
- 🌐 **Sincronização opcional** — você decide o servidor (auto-hospedado se quiser)

</div>

<div>

### Permissões usadas
<div class="card">

📍 **Localização** — para registrar GPS dos espécimes

</div>
<div class="card">

📷 **Câmera** — para fotos dos espécimes

</div>
<div class="card">

🎤 **Microfone** — para gravação de notas em áudio

</div>
<div class="card">

💾 **Armazenamento** — para fotos, áudios e exportações

</div>

</div>

</div>

---

# Fluxo completo: do mato ao herbário

```mermaid
flowchart LR
  A[🥾 Saída de campo] --> B[📋 Criar sessão]
  B --> C[⚡ Captura rápida<br/>foto + GPS + áudio]
  C --> D{Mais<br/>espécimes?}
  D -->|sim| C
  D -->|não| E[💾 Salvo offline]
  E --> F[🏠 Volta ao acampamento]
  F --> G[✍️ Completa fichas<br/>determinação, medidas]
  G --> H{Internet?}
  H -->|não| I[Continua trabalhando]
  I --> H
  H -->|sim| J[🔄 Sincroniza com servidor]
  J --> K[🏷️ Gera etiquetas PDF]
  J --> L[📤 Exporta CSV/Excel]
  J --> M[🌐 Envia ao iNaturalist]
```

---

<!-- _class: lead -->

# 🌿 Folium v1.9

## Pronto para a próxima expedição

<br>

**Disponível para Android · iOS · macOS · Linux · Web**

<br>

<div style="font-size:24px;color:var(--leaf-300);">
github.com/orcololo/field_book
</div>

<br>

<span class="badge">Offline-first</span>&nbsp;
<span class="badge">Open Source</span>&nbsp;
<span class="badge">Multi-plataforma</span>
