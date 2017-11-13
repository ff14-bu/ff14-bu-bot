require "ff14angler"

module Ruboty
  module Actions
    module FF14Angler
      class SearchFish < Base
        def call
          keyword = message.match_data[1]

          message.reply("#{keyword}を猫はお腹がすいたで検索します")

          body = search(keyword)
          message.reply(body)
        end

        private

        def search(keyword)
          fish = ::FF14Angler.client.search(keyword).find { |fish| fish.name == keyword }

          if fish.nil?
            return "#{keyword}は見つかりませんでした。"
          end

          fish.url
        end
      end
    end
  end
end
