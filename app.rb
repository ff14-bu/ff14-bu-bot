require 'discordrb'
require 'uri'
require 'nokogiri'
require 'net/http'

require 'pry'

ERIONES_URL = "https://eriones.com"

module Fetcher
  def self.list(search_word:)
    uri = URI.parse("https://eriones.com/tmp/load/db?il=1-275&img=on&i=#{URI.encode_www_form_component(search_word)}")
    request = Net::HTTP::Get.new(uri)

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    res
  end

  def self.get(search_word:)
    # 検索のリストの中から1件だったときに、その id を調べて ItemParser に食わせる
    res = self.list(search_word: search_word)

    items = ItemListParser.new(res.body).items

    if items.count == 1
      item = items.first

      uri = URI.parse("https://eriones.com/#{item.id}")
      request = Net::HTTP::Get.new(uri)
      req_options = {
        use_ssl: uri.scheme == "https",
      }

      res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      res
    else
      p "2件以上見つかったよ"
    end
  end
end

class Item
  attr_accessor :id, :name, :gatherers, :markets, :monsters, :npc_shops, :recipes

  def initialize(attributes)
    attributes.each do |k, v|
      send("#{k.to_s}=", v) if respond_to?("#{k.to_s}=")
    end if attributes
  end

  def eriones_path
    "#{ERIONES_URL}/#{@id}"
  end
end

class ItemListParser
  attr_accessor :doc

  def initialize(body)
    @doc = Nokogiri::HTML.parse(body)
  end

  def items
    @doc.xpath("/html/body//div[@class='searchcat-view']//p/a").map do |item|
      Item.new(id: item.attr("href"), name: item.children.first.text)
    end
  end
end

Gatherer = Struct.new(:klass, :lv, :type, :region_area, :position, :map_url)
Market = Struct.new(:market_information, :group, :il, :need_item, :need_amount)
Monster = Struct.new(:name, :area)
NpcShop = Struct.new(:name, :map, :coordinate, :area_name, :price)
Recipe = Struct.new(:name, :klass, :lv, :type, :recipe, :crystal)

class ItemParser
  def initialize(body)
    @doc = Nokogiri::HTML.parse(body)
  end

  def item
    Item.new(
      id: id,
      name: name,
      gatherers: gatherers,
      markets: markets,
      monsters: monsters,
      npc_shops: npc_shops,
      recipes: recipes
    )
  end

  def id
    @doc.xpath("/html//div[@id='box-fix']//h2/a").first.attr("href")
  end

  def name
    @doc.xpath("/html//div[@id='box-fix']//h3").first.text
  end

  def gatherers
    xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "クラス")]/parent::*/parent::*/tr'
    return nil if @doc.xpath(xpath).empty?
    rows = []
    @doc.xpath(xpath).each_with_index do |element, index|
      next if index == 0
      row = element.xpath("td")

      rows << Gatherer.new(
        row[0].text,
        row[1].text,
        row[2].text,
        row[3].text,
        row[4].text,
        "https:" + row[5].xpath("a").attr("href").text
      )
    end
    rows
  end

  def markets
    xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "取引情報")]/parent::*/parent::*/tr'
    return nil if @doc.xpath(xpath).empty?

    rows = []
    @doc.xpath(xpath).each_with_index do |element, index|
      next if index == 0
      row = element.xpath("td")

      rows << Market.new(
        row[0].text,
        row[1].text,
        row[2].text,
        row[3].text,
        row[4].text
      )
    end
    rows
  end

  def monsters
    xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "モンスター名")]/parent::*/parent::*/tr'
    return nil if @doc.xpath(xpath).empty?

    rows = []
    @doc.xpath(xpath).each_with_index do |element, index|
      next if index == 0
      row = element.xpath("td")

      rows << Monster.new(
        row[0].text,
        row[1].text
      )
    end
    rows
  end

  def npc_shops
    xpath = '//*[@id="box-fix"]//table/tr/th[contains(text(), "NPC名")]/parent::*/parent::*/tr'
    return nil if @doc.xpath(xpath).empty?

    rows = []
    @doc.xpath(xpath).each_with_index do |element, index|
      next if index == 0
      row = element.xpath("td")

      rows << NpcShop.new(
        row[0].text,
        row[1].text,
        row[2].text,
        row[3].text,
        row[4].text
      )
    end
    rows
  end

  def recipes
    # https://eriones.com/tmp/load/table?iid=#{id}
  end
end

class Decorator
  attr_accessor :event, :keyword

  def initialize(event, keyword)
    @event = event
    @keyword = keyword
  end

  def render
    @event
  end

  def search_item_list
    @event << "#{keyword}をエリオネスで検索します\n"

    res = Fetcher.list(search_word: keyword)
    parser = ItemListParser.new(res.body)
    items = parser.items

    event << "#{items.count}件のアイテムが見つかりました。\n"
    items.each do |item|
      @event << "#{item.name} - #{item.eriones_path} \n"
    end
  end

  def find_item_page(with:)
    res = Fetcher.get(search_word: keyword)
    item = ItemParser.new(res.body).item

    if item.id.nil?
      @event << "#{keyword}はエリオネスでは見つかりませんでした \n"
      @event << "#{ERIONES_URL}/search?i=#{keyword}"
      return
    end

    @event << "#{keyword}をエリオネスで検索します\n"
    case with
    when :summary
      @event << "#{item.name}は\n"
      exist = []
      exist << "ギャザラー情報" if item.gatherers
      exist << "入手情報" if item.markets
      exist << "モンスター情報" if item.monsters
      exist << "ショップ情報" if item.npc_shops
      @event << exist.join(", ")
      @event << "の情報が見つかりました。"
    when :gatherer
      @event << "#{item.name}のギャザラー情報は\n"

      if item.gatherers.nil?
        @event << "みつかりませんでした"
      else
        item.gatherers.each do |g|
          @event << "- クラス: #{g.klass}, LV: #{g.lv}, タイプ: #{g.type}, リージョンエリア: #{g.region_area}, 位置: #{g.position} \n"
          @event << "- #{g.map_url}"
        end
      end
    when :market
      @event << "#{item.name}の入手情報は\n"

      if item.markets.nil?
        @event << "みつかりませんでした"
      else
        item.markets.each do |m|
          @event << "- 取引情報 #{m.market_information}, 部類: #{m.group}, IL: #{m.il}, 必要アイテム #{m.need_item}, 必要数: #{m.need_amount} \n"
        end
      end
    when :monster
      @event << "#{item.name}のモンスター情報は\n"

      if item.monsters.nil?
        @event << "みつかりませんでした"
      else
        item.monsters.each do |m|
          @event << "- モンスター名 #{m.name}, エリア: #{m.area}"
        end
      end
    when :npc_shop
      @event << "#{item.name}のショップ情報は\n"

      if item.monsters.nil?
        @event << "みつかりませんでした"
      else
        item.npc_shops.each do |m|
          @event << "- NPC名 #{m.name}, マップ 座標: #{m.map}, 販売価格: #{m.price}"
        end
      end

    end
    @event << "#{item.eriones_path}\n"
  end
end

token = ENV["DISCORD_BOT_TOKEN"]
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
  when 3
    case args[1]
    when "ギャザラー情報"
      decorator.find_item_page(with: :gatherer)
    when "入手情報"
      decorator.find_item_page(with: :market)
    when "モンスター情報"
      decorator.find_item_page(with: :monster)
    when "ショップ情報"
      decorator.find_item_page(with: :npc_shop)
    end
  end

  decorator.render
end

bot.run
