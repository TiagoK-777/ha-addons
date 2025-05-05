# 📖 Jina Reader Add-on for Home Assistant

O **Jina Reader Add-on** permite que o Home Assistant utilize um crawler/headless browser baseado em Node.js e Puppeteer para capturar conteúdos de páginas web. Ideal para gerar screenshots, extrair dados estruturados (Markdown, HTML, texto) ou analisar conteúdo de sites com seletor CSS.

---

## Este addon está sendo útil?
[![Suporte](https://img.shields.io/badge/Donation-Nubank-blue)](https://nubank.com.br/cobrar/nv10d/6813fc28-be53-463c-bc19-b7b565a009e4)  

Considere fazer uma doação para apoiar o desenvolvimento e manter este projeto ativo! 🙏  
Qualquer valor é bem-vindo e ajuda muito ❤️  

---

## 🚀 Funcionalidade

- 🌐 Navegação headless com Chromium/Google Chrome
- 📸 Captura de páginas (`screenshot`, `pageshot`)
- 📝 Retorno estruturado (`markdown`, `html`, `text`)
- 🔎 Espera por seletores (`X-Wait-For-Selector`)
- ✂️ Remoção de elementos via CSS (`X-Remove-Selector`)
- ⚙️ Proxy, timeout e geração automática de alt-text
- 📂 Armazena screenshots em `/homeassistant/reader-screenshot`

---

## 🔗 Endpoints disponíveis

### `GET /r/{url}`

Faz o _crawl_ da URL informada e retorna o conteúdo de acordo com os headers.

#### Headers suportados:
| Header                    | Tipo     | Descrição                                                                 |
|--------------------------|----------|---------------------------------------------------------------------------|
| `X-Respond-With`         | string   | `markdown`, `html`, `text`, `pageshot`, `screenshot`                      |
| `X-Wait-For-Selector`    | string   | CSS selector a esperar antes de renderizar                               |
| `X-Target-Selector`      | string   | Seleciona elementos específicos                                           |
| `X-Remove-Selector`      | string   | Remove elementos da página antes do retorno                              |
| `X-Timeout`              | inteiro  | Tempo máximo de espera (até 180s)                                         |
| `X-Proxy-Url`            | string   | Define um proxy HTTP/S                                                   |
| `X-With-Generated-Alt`   | boolean  | Gera automaticamente `alt` para imagens                                   |
| `X-With-Images-Summary`  | boolean  | Retorna resumo de imagens encontradas                                     |
| `X-With-Links-Summary`   | boolean  | Retorna resumo de links encontrados                                       |

---

## 🧪 Exemplo de uso (CURL)

```
curl --request GET \
  --url "http://homeassistant.local:50893/r/https://example.com" \
  --header 'X-Respond-With: markdown' \
  --header 'X-Target-Selector: body > div > h1, body > div > p:nth-child(2)' \
  --header 'X-Timeout: 30' \
  --header 'X-Wait-For-Selector: head'
```
