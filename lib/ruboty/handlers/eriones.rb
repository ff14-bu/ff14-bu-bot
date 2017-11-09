module Ruboty
  module Handlers
    class Eriones < Base
      on(
        /\A[!\/]gather\s+(.*)\z/i,
        name: "gather",
        description: "アイテム名のギャザラー情報を探します。",
        all: true
      )

      on(
        /\A[!\/]hunt\s+(.*)\z/i,
        name: "hunt",
        description: "モンスターから得られるアイテムの情報を探します。",
        all: true
      )

      on(
        /\A[!\/]market\s+(.*)\z/i,
        name: "market",
        description: "アイテムの入手情報を探します。",
        all: true
      )

      on(
        /\A[!\/]shop\s+(.*)\z/i,
        name: "shop",
        description: "アイテムのショップ情報を探します。",
        all: true
      )

      on(
        /\A[!\/]recipe\s(.*)\z/i,
        name: "recipe",
        description: "アイテムのレシピを探します",
        all: true
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
