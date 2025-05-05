[![Build & test](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/build-test.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/build-test.yml)
[![Deploys](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/deploy.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/deploy.yml)
[![Release Charts](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/helm-chart-release.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/helm-chart-release.yml)
[![Update Dev/Beta Browser Images](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/update-dev-beta-browser-images.yml/badge.svg)](https://github.com/SeleniumHQ/docker-selenium/actions/workflows/update-dev-beta-browser-images.yml)
[![Releases downloads](https://img.shields.io/github/downloads/seleniumhq/docker-selenium/total.svg)](https://github.com/SeleniumHQ/docker-selenium/releases)
[![Suporte](https://img.shields.io/badge/Donation-Nubank-blue)](https://nubank.com.br/cobrar/nv10d/6813fc28-be53-463c-bc19-b7b565a009e4)

# Selenium Grid Standalone Add-on

Este add-on executa o Selenium Grid Standalone dentro do ambiente do Home Assistant, permitindo controlar navegadores remotamente por meio de fluxos no Node-RED.

## Integração com Node-RED

Para utilizar este serviço com o Node-RED, siga os passos abaixo:

1. **Instale o nó adicional no Node-RED:**

`node-red-contrib-simple-webdriver`

2. **Configure o nó `browser` com a seguinte URL:**

`http://homeassistant:4444`

Isso conectará o Node-RED ao Selenium Grid Standalone, possibilitando a automação de ações em navegadores como abrir páginas, clicar em elementos, preencher formulários e muito mais.

## Porta padrão

O Selenium Grid Standalone escuta na porta `4444` por padrão.

---

Ideal para quem deseja realizar automações avançadas envolvendo controle de páginas web a partir do Home Assistant.

