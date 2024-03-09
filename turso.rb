require 'dotenv/load'
require 'faraday'

def turso_insert(lat, lon, acc, alt, batt, constat, tst, vst, vel, trig)
  url = ENV['TURSO_URL'] + '/v2/pipeline'
  auth_token = ENV['TURSO_AUTH']
  conn = Faraday.new(
    url: url,
    headers: {
      "Authorization" => "Bearer #{auth_token}",
      "Content-Type" => "application/json",
    }
  )
  response = conn.post do |req|
    stmt = "INSERT into #{ENV['TABLE_NAME']} (lat, lon, accuracy, altitude, battery, connectivity, timestamp, vertical_accuracy, velocity, trig) VALUES"\
      + "(#{lat}, #{lon}, #{acc}, #{alt}, #{batt}, #{constat.to_s.dump}, #{tst}, #{vst}, #{vel}, #{trig});"
    req.body = {
      "requests": [
        { "type": "execute", "stmt": { "sql":  stmt} },
        { "type": "close" }
      ]
    }.to_json
  end

  response
end
