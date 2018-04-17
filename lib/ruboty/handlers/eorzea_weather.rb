require "ruboty/actions/eorzea_weather/pazuzu"

module Ruboty
  module Handlers
    class EorzeaWeather < Base
      on(
        /pazuzu/i,
        name: "pazuzu",
        description: "",
      )

      def pazuzu(message)
        Ruboty::Actions::EorzeaWeather::Pazuzu.new(message).call
      end
    end
  end
end
