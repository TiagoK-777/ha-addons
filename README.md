# Thunderbolt Add-ons para Home Assistant

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FTiagoK-777%2Fha-addons)

Repositório de add-ons para o **Home Assistant** que ampliam as capacidades de automação residencial com APIs de mensageria, automação de navegador web, notificações de câmeras, cache de dados e extração de conteúdo da web.

---

## Como instalar este repositório no Home Assistant

1. No Home Assistant, vá em **Configurações** > **Add-ons** > **Loja de Add-ons**
2. Clique no menu de três pontos (⋮) no canto superior direito
3. Selecione **Repositórios**
4. Cole o seguinte URL:

   ```
   https://github.com/TiagoK-777/ha-addons
   ```

5. Clique em **Adicionar**

Ou clique direto no botão azul acima para adicionar automaticamente.

---

## Add-ons disponíveis

| Add-on | Descrição | Caso de uso no Home Assistant |
|---|---|---|
| **[Evolution API](evolution-api-addon/)** | API completa para controle do WhatsApp via HTTP — envie/receba mensagens, mídia e crie chatbots | Notificações via WhatsApp, chatbots de atendimento, automação de respostas |
| **[WPPConnect Server](wpp-connect-addon/)** | Servidor que expõe uma API REST para controlar o WhatsApp Web | Envio de mensagens automáticas, leitura de mensagens recebidas, geração de QR Code para login |
| **[Selenium Grid Standalone](selenium-chrome-addon/)** | Navegador Chrome controlado remotamente via WebDriver — ideal para automação web | Coletar dados de sites que não têm API, preencher formulários, tirar screenshots de páginas |
| **[Jina AI's Reader](jina-reader-addon/)** | Converte qualquer URL em texto limpo (Markdown, HTML, texto puro) — ótimo para alimentar IA ou fazer resumos | Extrair conteúdo de notícias, transformar páginas web em resumos, alimentar assistentes de IA |
| **[Redis](redis-addon/)** | Banco de dados em memória ultra-rápido para cache e mensageria | Compartilhar estado entre automações, cache de dados temporários, filas de mensagens |
| **[Frigate Notify](frigate-notify-addon/)** | Envia alertas do Frigate NVR (câmeras de segurança) para Discord, Telegram, e-mail e mais | Ser notificado quando suas câmeras detectarem pessoas, veículos ou eventos relevantes |

---

## Arquitetura típica de uso

```
┌──────────────────────────────────────────────────────────┐
│                    Home Assistant                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐               │
│  │Automações│  │ Node-RED │  │  n8n     │               │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘               │
│       │             │             │                      │
│       └─────────────┼─────────────┘                      │
│                     │                                    │
│         ┌───────────┴───────────┐                        │
│         │   Thunderbolt Add-ons │                        │
│         │                       │                        │
│         │  • WhatsApp (Evolution│                        │
│         │    API / WPPConnect)  │                        │
│         │  • Selenium (Chrome)  │                        │
│         │  • Jina Reader        │                        │
│         │  • Redis (cache)      │                        │
│         │  • Frigate Notify     │                        │
│         └───────────────────────┘                        │
└──────────────────────────────────────────────────────────┘
```

---

## Requisitos

- **Home Assistant** com **Supervisor** (Home Assistant OS ou Supervised)
- Arquitetura `amd64` (suporte a `aarch64` para Redis e Frigate Notify)
- Conexão com internet para Download das imagens Docker

---

## Suporte

Cada add-on tem sua própria documentação detalhada. Acesse a pasta de cada um para saber mais.

Encontrou um problema? Abra uma [issue](https://github.com/TiagoK-777/ha-addons/issues).

---

## Doações

Este projeto é mantido voluntariamente. Se algum add-on foi útil para você, considere apoiar:

[![Suporte via Nubank](https://img.shields.io/badge/Doação-Nubank-blue)](https://nubank.com.br/cobrar/nv10d/6813fc28-be53-463c-bc19-b7b565a009e4)
