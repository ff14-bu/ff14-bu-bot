require "nokogiri"
require "eriones/models/item"

module Eriones
  module Parsers
    class ItemListParser
      attr_reader :doc

      def initialize(body)
        @doc = Nokogiri::HTML.parse(body)
      end

      def items
        doc.xpath("//div[@class='searchcat-view']//p/a[@href]").map do |item|
          name = item.children.first.text
          ::Eriones::Models::Item.new(id: item.attr("href"), name: name)
        end
      end
    end
  end
end
