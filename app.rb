client_id = ENV["DISCORD_CLIENT_ID"]

bot = Discordrb::Commands::CommandBot.new token: token, client_id: client_id, prefix: '/'

bot.command :eriones do |event, *args|
  # /eriones ボムの灰
  # /eriones ボムの灰 について
  # /eriones ボムの灰 ギャザラー について
  decorator = Decorator.new(event, args[0])
  case args.count
  when 1
    decorator.search_item_list
  when 2
    decorator.find_item_page(with: :summary)
  end

  decorator.render
end

bot.command :gather do |event, *args|
  decorator = Decorator.new(event, args[0])
  decorator.find_item_page(with: :gatherer)

  decorator.render
end

bot.command :market do |event, *args|
  decorator = Decorator.new(event, args[0])
  decorator.find_item_page(with: :market)

  decorator.render
end

bot.command :monster do |event, *args|
  decorator = Decorator.new(event, args[0])
  decorator.find_item_page(with: :monster)

  decorator.render
end

bot.command :npc_shop do |event, *args|
  decorator = Decorator.new(event, args[0])
  decorator.find_item_page(with: :npc_shop)

  decorator.render
end

bot.run
