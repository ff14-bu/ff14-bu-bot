require 'ff14angler/client'

module FF14Angler
  class << self
    def client(options = {})
      FF14Angler::Client.new(options)
    end
  end
end
