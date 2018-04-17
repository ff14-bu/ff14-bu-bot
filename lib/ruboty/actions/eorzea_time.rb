require 'eorzea_time'

module Ruboty
  module Actions
    class EorzeaTime < Base
      def call
        message.reply(time)
      end

      private

      def time
        t = ::EorzeaTime.now
        "ET #{t.to_s}"
      end
    end
  end
end
