require 'uri'
require 'nokogiri'
require 'net/http'

ERIONES_URL = "https://eriones.com"

require './decorator'
require './fetcher'
require './item_list_parser'
require './item_parser'
require './item'

module Ruboty
  module Handlers
    class Eriones < Base
      on(
        /gather (.*)/i,
        name: "gather",
        description: "アイテム名のギャザラー情報を探します。"
      )

      on(
        /hunt (.*)/i,
        name: "hunt",
        description: "モンスターから得られるアイテムの情報を探します。"
      )

      on(
        /market (.*)/i,
        name: "market",
        description: "アイテムの入手情報を探します。"
      )

      on(
        /shop (.*)/i,
        name: "shop",
        description: "アイテムのショップ情報を探します。"
      )

      on(
        /recipe (.*)/i,
        name: "recipe",
        description: "アイテムのレシピを探します"
      )

      def gather(message)
        decorator = Decorator.new(message.match_data[1])
        decorator.find_item_page(with: :gatherer)
        message.reply(decorator.render)
      end

      def hunt(message)
        decorator = Decorator.new(message.match_data[1])
        decorator.find_item_page(with: :monster)
        message.reply(decorator.render)
      end

      def market(message)
        decorator = Decorator.new(message.match_data[1])
        decorator.find_item_page(with: :market)
        message.reply(decorator.render)
      end

      def shop(message)
        decorator = Decorator.new(message.match_data[1])
        decorator.find_item_page(with: :npc_shop)
        message.reply(decorator.render)
      end

      def recipe
        raise "No implements"
      end
    end
  end
end
