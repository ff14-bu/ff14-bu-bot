require 'discordrb'

token = ENV["DISCORD_BOT_TOKEN"]
client_id = ENV["DISCORD_CLIENT_ID"]

bot = Discordrb::Bot.new token: token, client_id: client_id

bot.mention(contains: 'ping') do |event|
  event.respond 'pong'
end

bot.run
