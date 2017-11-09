module Ruboty
  module Actions
    class EorzeaTime < Base
      def call
        message.reply(time)
      end

      private

      def time
        now = Time.at(Time.now.utc.to_i * 1440 / 70).utc
        "ET #{"%02d" % now.hour}時#{"%02d" % now.min}分です"
      end
    end
  end
end
