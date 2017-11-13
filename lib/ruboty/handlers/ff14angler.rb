module Ruboty
  module Handlers
    class Eriones < Base
      on(
        /\A[!\/]fish\s+(.*)\z/i,
        name: "fish",
        description: "魚の情報を探します。",
        all: true
      )

      def fish(message)
        Ruboty::Actions::FF14Angler::SearchFish.new(message).call
      end
    end
  end
end
