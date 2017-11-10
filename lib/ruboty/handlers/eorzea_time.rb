module Ruboty
  module Handlers
    class Eriones < Base
      on(
        /(:?(:?今|いま)(:?[、,]\s*)?)?(:?何時|なんじ)(:?で(:?しょう?|す)か?)?[\?？]*\z/,
        name: "eorzea_time",
        description: ""
      )

      def eorzea_time(message)
        Ruboty::Actions::EorzeaTime.new(message).call
      end
    end
  end
end
