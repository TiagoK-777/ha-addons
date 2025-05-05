# WPPConnect Server CLI

## Nossos canais online

Esse pacote facilita a utilizacao do servidor WPPConnect server atraves de uma linha de comando

[![Discord](https://img.shields.io/discord/844351092758413353?color=blueviolet&label=Discord&logo=discord&style=flat)](https://discord.gg/JU5JGGKGNG)
[![Telegram Group](https://img.shields.io/badge/Telegram-Group-32AFED?logo=telegram)](https://t.me/wppconnect)
[![WhatsApp Group](https://img.shields.io/badge/WhatsApp-Group-25D366?logo=whatsapp)](https://chat.whatsapp.com/LJaQu6ZyNvnBPNAVRbX00K)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UCD7J9LG08PmGQrF5IS7Yv9A?label=YouTube)](https://www.youtube.com/c/wppconnect)

---

## Este addon está sendo útil?
[![Suporte](https://img.shields.io/badge/Donation-Nubank-blue)](https://nubank.com.br/cobrar/nv10d/6813fc28-be53-463c-bc19-b7b565a009e4)  

Considere fazer uma doação para apoiar o desenvolvimento e manter este projeto ativo! 🙏  
Qualquer valor é bem-vindo e ajuda muito ❤️  

---

## Documentação da api

```
http://homeassistant:21465/api-docs/
```

## Criar sessão e gerar token

```
curl --request POST \
  --url http://homeassistant:21465/api/NOME-DA-SESSAO/minha-chave-secreta/generate-token \
  --header 'accept: */*'
```

## Iniciar sessão

```
curl --request POST \
  --url http://homeassistant:21465/api/NOME-DA-SESSAO/start-session \
  --header 'Authorization: Bearer MEU_TOKEN_SUPER_SECRETO' \
  --header 'Content-Type: application/json' \
  --header 'accept: */*' \
  --data '{
   "webhook": "",
   "waitQrCode": true
 }'
```

## Gerar qrcode

```
curl --request GET \
  --url http://homeassistant:21465/api/NOME-DA-SESSAO/qrcode-session \
  --header 'Authorization: Bearer MEU_TOKEN_SUPER_SECRETO' \
  --header 'accept: */*'
```

## Enviar mensagem
 
```
curl --request POST \
  --url http://homeassistant:21465/api/NOME-DA-SESSAO/send-message \
  --header 'Authorization: Bearer MEU_TOKEN_SUPER_SECRETO' \
  --header 'Content-Type: application/json' \
  --header 'accept: */*' \
  --data '{
    "phone": "5555999999999",
    "isGroup": false,
    "isNewsletter": false,
    "isLid": false,
    "message": "Hi from WPPConnect"  
 }'
```

## Tutorial - Youtube
- Veja o tutorial de uso no [Canal WPPConnect](https://www.youtube.com/watch?v=zBmCnPS3JOQ).
