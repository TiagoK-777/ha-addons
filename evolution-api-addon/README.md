<h1 align="center">Evolution Api</h1>

<div align="center">

[![Grupo Whatsapp](https://img.shields.io/badge/Group-WhatsApp-%2322BC18)](https://evolution-api.com/whatsapp)
[![Comunidade Discord](https://img.shields.io/badge/Discord-Community-blue)](https://evolution-api.com/discord)
[![Coleção Postman](https://img.shields.io/badge/Postman-Collection-orange)](https://evolution-api.com/postman) 
[![Documentação](https://img.shields.io/badge/Documentation-Official-green)](https://doc.evolution-api.com)
[![Licença](https://img.shields.io/badge/license-Apache--2.0-blue)](./LICENSE)
[![Suporte](https://img.shields.io/badge/Donation-picpay-green)](https://app.picpay.com/user/davidsongomes1998)
[![Patrocinadores](https://img.shields.io/badge/Github-sponsor-orange)](https://github.com/sponsors/EvolutionAPI)

A Evolution API começou como uma API de controlador do WhatsApp baseada em [CodeChat](https://github.com/code-chat-br/whatsapp-api), que, por sua vez, implementou a biblioteca [Baileys](https://github.com/WhiskeySockets/Baileys). Embora originalmente focada no WhatsApp, a Evolution API tornou-se uma plataforma abrangente que suporta vários serviços de mensagens e integrações. Continuamos a reconhecer o CodeChat por estabelecer as bases.

Hoje, a API Evolution não se limita ao WhatsApp. Ela se integra a várias plataformas, como Typebot, Chatwoot, Dify e OpenAI, oferecendo uma ampla gama de funcionalidades além das mensagens. A Evolution API suporta tanto a API do WhatsApp baseada em Baileys quanto a API oficial do WhatsApp Business, com suporte futuro para Instagram e Messenger.

---

## Este addon está sendo útil?
[![Suporte](https://img.shields.io/badge/Donation-Nubank-blue)](https://nubank.com.br/cobrar/nv10d/6813fc28-be53-463c-bc19-b7b565a009e4)  

Considere fazer uma doação para apoiar o desenvolvimento e manter este projeto ativo! 🙏  
Qualquer valor é bem-vindo e ajuda muito ❤️  

---

## Configuração (Exemplo)

Este é um exemplo de como seu arquivo de configuração do add-on (geralmente na aba "Ajustes" do add-on no Home Assistant) pode ser estruturado. **Substitua os valores de exemplo pelos seus próprios.**

```yaml
# Configuração do servidor
SERVER_TYPE: http # Tipo de servidor (http, https)
SERVER_HOST: "homeassistant" # Host onde o servidor será executado
SERVER_PORT: 49152 # Porta para acesso ao servidor
TZ: "America/Sao_Paulo" # Fuso horário para registro de logs e eventos

# Configuração do banco de dados
DATABASE_PROVIDER: postgresql # Banco de dados utilizado
DATABASE_USER: "user" # Usuário do banco de dados
DATABASE_PASSWORD: "pass" # Senha do banco de dados
DATABASE_CONNECTION_URI: 'postgresql://user:pass@localhost:5432/evolution?schema=public' # URI completa para conexão com o banco de dados

# Autenticação
AUTHENTICATION_API_KEY: minha-senha-secreta # Chave de autenticação para acesso à API

# Configurações adicionais
CUSTOM_ENV: DATABASE_SAVE_IS_ON_WHATSAPP_DAYS=1 DATABASE_SAVE_DATA_HISTORIC=false DATABASE_SAVE_DATA_NEW_MESSAGE=false # Variáveis de configuração adicionais, separadas por espaço
```

## 🔒 Recomendações de Segurança

> ⚠️ **Importante:** Troque imediatamente o `DATABASE_USER`, `DATABASE_PASSWORD` e a `AUTHENTICATION_API_KEY` por valores seguros e únicos para garantir a segurança do seu sistema.


É necessário atualizar o `DATABASE_CONNECTION_URI` com o mesmo "user" e "pass" definidos em `DATABASE_USER` e `DATABASE_PASSWORD`


## 📋 Exemplos de Configuração Avançada (`CUSTOM_ENV`)

É possível definir outras variáveis de ambiente na seção `CUSTOM_ENV` para ajustar o comportamento do servidor conforme suas necessidades.

As variáveis em `CUSTOM_ENV` devem ser listadas na mesma linha, separadas por espaços.

*   **Para armazenar o histórico de mensagens:**
    ```yaml
    DATABASE_SAVE_DATA_HISTORIC=true OUTRAS_VARIAVEIS=valor ...
    ```

*   **Para alterar o tempo de retenção da informação "contato está no WhatsApp":**
    ```yaml
    DATABASE_SAVE_IS_ON_WHATSAPP_DAYS=7 OUTRAS_VARIAVEIS=valor ...
    ```
Um exemplo com as variáveis de ambiente disponíveis podem ser encontradas [aqui](https://github.com/EvolutionAPI/evolution-api/blob/main/.env.example).


## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir *issues* ou enviar *pull requests* para melhorias.