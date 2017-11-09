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
        Ruboty::Actions::Eriones::SearchItem.new(message, with: :gatherer).call
      end

      def hunt(message)
        Ruboty::Actions::Eriones::SearchItem.new(message, with: :monster).call
      end

      def market(message)
        Ruboty::Actions::Eriones::SearchItem.new(message, with: :market).call
      end

      def shop(message)
        Ruboty::Actions::Eriones::SearchItem.new(message, with: :npc_shop).call
      end

      def recipe
        raise NotImplementedError, "No implements"
      end
    end
  end
end
