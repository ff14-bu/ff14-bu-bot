require 'nokogiri'

module FF14Angler
  class Response
    def initialize(body)
      @doc = Nokogiri::HTML.parse(body)
    end

    def query(path)
      @doc.xpath(path)
    end
  end
end
