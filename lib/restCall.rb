require 'net/https'
require 'Faraday'

def restCall(server, endpoint, l, type)
  begin
    endpoint = URI.encode(endpoint)
    conn = Faraday.new(:url => 'https://' + server['servers'].sample(1)[0], request: {
        open_timeout: 5, # opening a connection
        timeout: 360 # waiting for response
    })
    conn.basic_auth decrypt(server['username'], Options.cluster), decrypt(server['password'], Options.cluster)
    conn.headers['Authorization']
    conn.ssl.verify = false
    response = conn.public_send(type) do |req|
      req.url endpoint
      req.headers['Content-Type'] = 'application/json'
      req.body = l.to_json
    end
    if response.status !~ /202|200/
      begin
        return JSON.parse(response.body)
      rescue
        return "Empty Response"
      end
    end
  rescue Faraday::ConnectionFailed
    @error = "There was a timeout. Please try again."
  end

end
