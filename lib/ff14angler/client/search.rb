require 'uri'
require 'ff14angler/models/fish'

module FF14Angler
  class Client
    module Search
      def search(keyword)
        path     = "/?search=#{URI.encode_www_form_component(keyword)}"
        response = get(path)
        nodes    = response.query('//h4[text() = "魚類"]/following-sibling::*[@class="search_result"][1]//a[@href]')
        nodes.map do |node|
          uri = URI.join(endpoint, node.attr('href'))
          id  = (uri.path.split('/', 3)[2] || 0).to_i

          id.zero? ? nil : FF14Angler::Models::Fish.new(id, node.text, uri.to_s)
        end.compact
      end
    end
  end
end
