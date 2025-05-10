[![Build & test](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/build-test.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/build-test.yml)
[![Deploys](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/deploy.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/deploy.yml)
[![Release Charts](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/helm-chart-release.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/helm-chart-release.yml)
[![Update Dev/Beta Browser Images](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/update-dev-beta-browser-images.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/update-dev-beta-browser-images.yml)
[![Releases downloads](https://img.shields.io/github/downloads/seleniumhq/docker-selenium/total.svg)](https://github.com/SeleniumHQ/docker-selenium/releases)
[![Suporte](https://img.shields.io/badge/Donation-Nubank-blue)](https://nubank.com.br/cobrar/nv10d/6813fc28-be53-463c-bc19-b7b565a009e4)

# Selenium Grid Standalone Add-on

Este add-on executa o Selenium Grid Standalone dentro do ambiente do Home Assistant, permitindo o controle automatizado de navegadores via Node-RED.

## Integração com Node-RED

Para utilizar com o Node-RED, siga os passos abaixo:

1. **Instale o nó adicional:**

   ```bash
   node-red-contrib-simple-webdriver
   ```

2. **Configure o nó `open browser` com a seguinte URL:**

   ```
   http://homeassistant:4444
   ```

Isso conecta o Node-RED ao Selenium Grid Standalone, permitindo automatizar ações como abrir páginas, clicar em botões, preencher formulários e muito mais.

## Porta padrão

O serviço escuta por padrão na porta `4444`.

---

Ideal para automações avançadas com navegação web diretamente integradas ao Home Assistant.


