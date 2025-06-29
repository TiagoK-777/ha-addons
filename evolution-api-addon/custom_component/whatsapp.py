import requests
from url_normalize import url_normalize

class Whatsapp:
    def __init__(self, host=None, api_key=None, client_id=None):
        self.host = host or 'http://homeassistant:49152'
        self.api_key = api_key
        self.client_id = client_id or 'default'

    def send_message(self, data):
        endpoint = f'{self.host}/message/sendText/{data.get("clientId", self.client_id)}'
        headers = {
            'Content-Type': 'application/json',
            'apikey': data.get('apikey', self.api_key or '')
        }
        payload = {
            'number': data['to'].split('@')[0],
            'text': data['message'],
            'delay': data.get('delay', 1200),
            'linkPreview': data.get('linkPreview', False)
        }
        return requests.post(url_normalize(endpoint), headers=headers, json=payload).status_code == 200

    def send_media(self, data):
        endpoint = f'{self.host}/message/sendMedia/{data.get("clientId", self.client_id)}'
        headers = {
            'Content-Type': 'application/json',
            'apikey': data.get('apikey', self.api_key or '')
        }
        payload = {
            'number': data['to'].split('@')[0],
            'mediatype': data.get('mediatype'),
            'mimetype': data.get('mimetype'),
            'caption': data.get('caption', ''),
            'media': data['media'],
            'fileName': data.get('fileName'),
            'delay': data.get('delay', 1200),
            'linkPreview': data.get('linkPreview', False)
        }
        return requests.post(url_normalize(endpoint), headers=headers, json=payload).status_code == 200
    def send_audio(self, data):
        endpoint = f'{self.host}/message/sendWhatsAppAudio/{data.get("clientId", self.client_id)}'
        headers = {
            'Content-Type': 'application/json',
            'apikey': data.get('apikey', self.api_key or '')
        }
        payload = {
            'number': data['to'].split('@')[0],
            'audio': data['audio'],
            'delay': data.get('delay', 1200),
            'linkPreview': data.get('linkPreview', False)
        }
        return requests.post(url_normalize(endpoint), headers=headers, json=payload).status_code == 200

