require 'eorzea_weather'

module Ruboty
  module Actions
    module EorzeaWeather
      class Pazuzu < Base
        def call
          reply = []

          if happening?
            reply << "パズズチャンス!"
            reply << "LT #{hms(next_gales.start_time)}-#{hms(next_gales.end_time)} (残り #{minutes(next_gales.end_time - now)} 分)"
          else
            reply << "次の暴風:"
            reply << "LT #{hms(next_gales.start_time)}-#{hms(next_gales.end_time)} (開始まで #{minutes(next_gales.start_time - now)} 分)"
          end

          reply << "\nその先:"
          upcoming_gales[1..5].map do |gales|
            reply << "- LT #{hms(gales.start_time)}-#{hms(gales.end_time)} (開始まで #{minutes(gales.start_time - now)} 分)"
          end

          message.reply(reply.join("\n"))
        end

        private

        def now
          @now ||= Time.now
        end

        def hms(time)
          time.localtime.strftime('%H:%M:%S')
        end

        def minutes(sec)
          "%.1f" % (sec/60.0)
        end

        def happening?
          next_gales.start_time <= now && now < next_gales.end_time
        end

        def next_gales
          upcoming_gales.first
        end

        def upcoming_gales
          @upcoming_gales ||= ::EorzeaWeather.find(:gales, :eureka_anemos)
        end
      end
    end
  end
end
