## Configuração (Exemplo)

Este é um exemplo de como seu arquivo de configuração do add-on (geralmente na aba "Ajustes" do add-on no Home Assistant) pode ser estruturado. **Substitua os valores de exemplo pelos seus próprios.**

```yaml
# Configuração do servidor
SERVER_TYPE: http # Tipo de servidor (http, https)
SERVER_HOST: "homeassistant" # Host onde o servidor será executado
SERVER_PORT: 49152 # Porta para acesso ao servidor
TZ: "America/Sao_Paulo" # Fuso horário para registro de logs e eventos
PERSISTENCE_DIR: "/data" # Onde os arquivos persistentes ficam armazenados*

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
* Os arquivos persistentes podem ser salvos em `/data` (mais seguro) ou `/config/addons_config/evolution-api` (acessível a partir do VSCode ou Terminal SSH).

---

## 🔒 Recomendações de Segurança

> ⚠️ **Importante:** Troque imediatamente o `DATABASE_USER`, `DATABASE_PASSWORD` e a `AUTHENTICATION_API_KEY` por valores seguros e únicos para garantir a segurança do seu sistema.


É necessário atualizar o `DATABASE_CONNECTION_URI` com o mesmo "user" e "pass" definidos em `DATABASE_USER` e `DATABASE_PASSWORD`

---

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

## ⚠️ Atenção: Pode ser preciso ajustar a versão do WhatsApp Web.

**O que fazer:**
1.  Acesse o WhatsApp Web.
2.  Vá em **Configurações** (⚙️) -> **Ajuda**.
3.  Anote o número da versão que aparece lá (ex: `2.3000.1023249347`).
4.  Em `CUSTOM_ENV`, ajuste ou crie a variável de ambiente `CONFIG_SESSION_PHONE_VERSION` com esse número.

*   **Exemplo:**
    ```yaml
    CONFIG_SESSION_PHONE_VERSION=2.3000.1023249347
    ```

Um exemplo com as variáveis de ambiente disponíveis podem ser encontradas [aqui](https://github.com/EvolutionAPI/evolution-api/blob/main/.env.example).

---

## 📋 Exemplos de Uso
*   **Fluxo para node-red:**
    Baixe o fluxo de exemplo [aqui](https://github.com/TiagoK-777/ha-addons/blob/main/documentos/exemplos/evolution-api/exemplo_node-red.json) e importe no Node-RED.

---

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir *issues* ou enviar *pull requests* para melhorias.