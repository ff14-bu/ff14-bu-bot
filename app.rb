require 'discordrb'
require 'uri'
require 'nokogiri'

require 'pry'

token = ENV["DISCORD_BOT_TOKEN"]
client_id = ENV["DISCORD_CLIENT_ID"]
eriones_endpoint = "https://eriones.com"
eriones_search_end_point = "#{eriones_endpoint}/tmp/load/db?il=1-275&img=on&i="
user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.75 Safari/537.36"

bot = Discordrb::Commands::CommandBot.new token: token, client_id: client_id, prefix: '/'

bot.command :eriones do |_event, *args|
  "#{args[0]}をエリオネスで検索します"

  uri = URI.parse(eriones_search_end_point + URI.encode_www_form_component(args[0]))

  req = Net::HTTP::Get.new(uri.path)
  #req["User-Agent"] = user_agent
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    http.request(req)
  end

  case res.code
  when Net::HTTPSuccess
    doc = Nokogiri::HTML.parse(res.body)
    #event.send(uri)
  else
  end
end

bot.run
