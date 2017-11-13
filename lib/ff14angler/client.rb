require 'ff14angler/connection'
require 'ff14angler/client/search'

module FF14Angler
  class Client
    attr_reader :endpoint

    include FF14Angler::Connection
    include FF14Angler::Client::Search

    def initialize(endpoint: 'http://jp.ff14angler.com/')
      @endpoint = endpoint
    end
  end
end
