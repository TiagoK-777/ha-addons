from __future__ import annotations

import logging

from .whatsapp import Whatsapp

from homeassistant.core import HomeAssistant, ServiceCall, callback
from homeassistant.helpers.typing import ConfigType

DOMAIN = "whatsapp"
_LOGGER = logging.getLogger(__name__)

async def async_setup(hass: HomeAssistant, config: ConfigType) -> bool:
    whatsapp_config = config.get(DOMAIN, {})
    whatsapp = Whatsapp(
        host=whatsapp_config.get('host'),
        api_key=whatsapp_config.get('api_key'),
        client_id=whatsapp_config.get('clientId')
    )

    @callback
    async def send_message(call: ServiceCall) -> None:
        await hass.async_add_executor_job(whatsapp.send_message, call.data)

    @callback
    async def send_media(call: ServiceCall) -> None:
        await hass.async_add_executor_job(whatsapp.send_media, call.data)

    @callback
    async def send_audio(call: ServiceCall) -> None:
        await hass.async_add_executor_job(whatsapp.send_audio, call.data)

    hass.services.async_register(DOMAIN, 'send_message', send_message)
    hass.services.async_register(DOMAIN, 'send_media', send_media)
    hass.services.async_register(DOMAIN, 'send_audio', send_audio)
    
    return True