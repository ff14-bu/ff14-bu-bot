require 'net/http'
require 'uri'
require 'ff14angler/response'

module FF14Angler
  module Connection
    def get(path)
      uri = URI.join(endpoint, path)
      Net::HTTP.start(uri.host, uri.port) do |http|
        path     = [uri.path, uri.query].compact.reject(&:empty?).join('?')
        response = http.get(path, {
          'Accept-Language' => 'ja',
        })
        FF14Angler::Response.new(response.body)
      end
    end
  end
end
