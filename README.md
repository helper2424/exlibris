# Gem to access ExLibris Alma API

Usage example:

```
api_key = 'your_api_key'
base_url = 'https://api-eu.hosted.exlibrisgroup.com'
api = Exlibris::Alma::Api.new api_keym base_url

mms_id = '123456789'
holdings_id = '1234'

p api.check_availability mms_id
p api.holdings mms_id
p api.loans mms_id
p api.holding_items mms_id, holdings_id

```
