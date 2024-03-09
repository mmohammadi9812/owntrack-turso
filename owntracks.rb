require 'date'
require 'digest/md5'
require 'dotenv/load'
require 'json'
require 'mqtt'
require 'telegram/bot'

require './turso'

address = ENV['MQTT_URL']
port = ENV['MQTT_PORT']
username = ENV['MQTT_USERNAME']
password = ENV['MQTT_PASSWORD']

token = ENV['TELEGRAM_TOKEN']
owner_id = ENV['MYTG_ID']

bot = Telegram::Bot::Client.new(token)

Signal.trap('INT') do
  bot.stop
end

puts 'starting to listen bot ...\n'
MQTT::Client.connect(host: address, port:, username:, password:, ssl: true, cert: ENV['EMQX_CERT'].strip ) do |client|
  client.get('owntracks/#') do |_, payload|
    data = JSON.parse(payload)
    if !data.key?('lat') || !data.key?('lon')
      return
    end
    lat = data['lat'].to_f
    lon = data['lon'].to_f
    accuracy = data['acc'].to_i
    trigger = data['t']
    timestamp = data['tst'].to_i
    # type = data['_type']
    # accuracy = data['acc'].to_i
    altitude = data['alt'].to_i
    battery = data['batt'].to_i
    # batt_stat = data['bs'].to_i
    connectivity_stat = data['conn']
    # created_at = data['created_at'].to_i
    vertical_accuracy = data['vst'].to_i
    velocity = data['vel'].to_i
    bot.api.send_location(chat_id: owner_id, latitude: lat, longitude: lon)
    resp = turso_insert(lat, lon, accuracy, altitude, battery, connectivity_stat, timestamp, vertical_accuracy, velocity, trigger)
    if resp.status != 200
      puts "insert into table was not successful: body: (#{resp.body}) status: (#{resp.status})"
    end
  end
end
