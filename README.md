# Owntracks
Using this code to track location using `owntrack` app and some worker (I'll update this later)

You need a turso account, a running emqx project, a new telegram bot, and update envrc.template

TURSO_URL: running `turso db show ${dbName} --http-url` gives you the url of api to your db named `dbName`

TURSO_AUTH: running `turso db tokens create ${dbName}` creates a token for you to use. Use `-e` flag to set expiration date

TABLE_NAME: name of the tables we're gonna insert into

MQTT_URL, MQTT_PORT, MQTT_USERNAME, MQTT_PASSWORD: your `emqx` database url, port, username & password

TELEGRAM_TOKEN: your telegram token

MYTG_ID: who's going to receive location updates?
