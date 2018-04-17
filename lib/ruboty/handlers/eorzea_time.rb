module Ruboty
  module Handlers
    class EorzeaTime < Base
      on(
        /et|eorzean?\s+time|(:?(:?今|いま)(:?[、,]\s*)?)?(:?何時|なんじ)(:?で(:?しょう?|す)か?)?[\?？]*\z/i,
        name: "eorzea_time",
        description: ""
      )

      def eorzea_time(message)
        Ruboty::Actions::EorzeaTime.new(message).call
      end
    end
  end
end
