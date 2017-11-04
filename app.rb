require 'discordrb'

token = ENV["DISCORD_BOT_TOKEN"]
client_id = ENV["DISCORD_CLIENT_ID"]

bot = Discordrb::Commands::CommandBot.new token: token, client_id: client_id, prefix: '/'

bot.mention(contains: 'ping') do |event|
  event.respond 'pong'
end

bot.command :eriones do |_event, *args|
  "#{args[0]}をエリオネスで検索します"
end

bot.run
