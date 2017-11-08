class Decorator
  attr_accessor :lines, :keyword

  def initialize(keyword)
    @lines = []
    @keyword = keyword
  end

  def render
    @lines.join("\n")
  end

  def search_item_list
    @lines << "#{keyword}をエリオネスで検索します"

    res = Fetcher.list(search_word: keyword)
    parser = ItemListParser.new(res.body)
    items = parser.items

    event << "#{items.count}件のアイテムが見つかりました。"
    items.each do |item|
      @lines << "#{item.name} - #{item.eriones_path} "
    end
  end

  def find_item_page(with:)
    res = Fetcher.get(search_word: keyword)
    item = ItemParser.new(res.body).item

    if item.id.nil?
      @lines << "#{keyword}はエリオネスでは見つかりませんでした "
      @lines << "#{ERIONES_URL}/search?i=#{keyword}"
      return
    end

    @lines << "#{keyword}をエリオネスで検索します"
    case with
    when :summary
      @lines << "#{item.name}は"
      exist = []
      exist << "ギャザラー情報" if item.gatherers
      exist << "入手情報" if item.markets
      exist << "モンスター情報" if item.monsters
      exist << "ショップ情報" if item.npc_shops
      @lines << exist.join(", ")
      @lines << "の情報が見つかりました。"
    when :gatherer
      @lines << "#{item.name}のギャザラー情報は"

      if item.gatherers.nil?
        @lines << "みつかりませんでした"
      else
        item.gatherers.each do |g|
          @lines << "- クラス: #{g.klass}, LV: #{g.lv}, タイプ: #{g.type}, リージョンエリア: #{g.region_area}, 位置: #{g.position} "
          @lines << "- #{g.map_url}"
        end
      end
    when :market
      @lines << "#{item.name}の入手情報は"

      if item.markets.nil?
        @lines << "みつかりませんでした"
      else
        item.markets.each do |m|
          @lines << "- 取引情報 #{m.market_information}, 部類: #{m.group}, IL: #{m.il}, 必要アイテム #{m.need_item}, 必要数: #{m.need_amount} "
        end
      end
    when :monster
      @lines << "#{item.name}のモンスター情報は"

      if item.monsters.nil?
        @lines << "みつかりませんでした"
      else
        item.monsters.each do |m|
          @lines << "- モンスター名 #{m.name}, エリア: #{m.area}"
        end
      end
    when :npc_shop
      @lines << "#{item.name}のショップ情報は"

      if item.monsters.nil?
        @lines << "みつかりませんでした"
      else
        item.npc_shops.each do |m|
          @lines << "- NPC名 #{m.name}, マップ 座標: #{m.map}, 販売価格: #{m.price}"
        end
      end

    end
    @lines << "#{item.eriones_path}"
  end
end
