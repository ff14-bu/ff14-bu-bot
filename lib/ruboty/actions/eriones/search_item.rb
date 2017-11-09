require "eriones/item_search"

module Ruboty
  module Actions
    module Eriones
      class SearchItem < Base
        attr_reader :with

        def initialize(message, with:)
          super(message)

          @with = with
        end

        def call
          keyword = message.match_data[1]

          message.reply("#{keyword}をエリオネスで検索します")

          body = search(keyword, with: with)
          message.reply(body)
        end

        private

        def search(keyword, options)
          ::Eriones::ItemSearch.search(keyword, options)
        end
      end
    end
  end
end
