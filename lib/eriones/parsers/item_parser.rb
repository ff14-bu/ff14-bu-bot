require "nokogiri"
require "eriones/models"
require "eriones/models/item"

module Eriones
  module Parsers
    class ItemParser
      attr_reader :doc

      def initialize(body)
        @doc = Nokogiri::HTML.parse(body)
      end

      def item
        ::Eriones::Models::Item.new(
          id: id,
          name: name,
          gatherers: gatherers,
          markets: markets,
          monsters: monsters,
          npc_shops: npc_shops,
          recipes: recipes
        )
      end

      def id
        doc.xpath("//div[@id='box-fix']//h2/a/@href").first.value
      end

      def name
        doc.xpath("//div[@id='box-fix']//h3").first.text
      end

      def gatherers
        xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "クラス")]/parent::*/parent::*/tr'
        result = doc.xpath(xpath)

        return nil if result.empty?

        rows = []
        result.each_with_index do |element, index|
          next if index == 0
          row = element.xpath("td")

          rows << ::Eriones::Models::Gatherer.new(
            row[0].text,
            row[1].text,
            row[2].text,
            row[3].text,
            row[4].text,
            "https:#{row[5].xpath("a/@href").first.value}"
          )
        end
        rows
      end

      def markets
        xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "取引情報")]/parent::*/parent::*/tr'
        result = doc.xpath(xpath)

        return nil if result.empty?

        rows = []
        result.each_with_index do |element, index|
          next if index == 0
          row = element.xpath("td")

          rows << ::Eriones::Models::Market.new(
            row[0].text,
            row[1].text,
            row[2].text,
            row[3].text,
            row[4].text
          )
        end
        rows
      end

      def monsters
        xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "モンスター名")]/parent::*/parent::*/tr'
        result = doc.xpath(xpath)
        return nil if result.empty?

        rows = []
        result.each_with_index do |element, index|
          next if index == 0
          row = element.xpath("td")

          rows << ::Eriones::Models::Monster.new(
            row[0].text,
            row[1].text
          )
        end
        rows
      end

      def npc_shops
        xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "NPC名")]/parent::*/parent::*/tr'
        result = doc.xpath(xpath)
        return nil if result.empty?

        rows = []
        result.each_with_index do |element, index|
          next if index == 0
          row = element.xpath("td")

          rows << ::Eriones::Models::NpcShop.new(
            row[0].text,
            row[1].text,
            row[2].text,
            row[3].text,
            row[4].text
          )
        end
        rows
      end

      def recipes
        # https://eriones.com/tmp/load/table?iid=#{id}
      end
    end
  end
end
