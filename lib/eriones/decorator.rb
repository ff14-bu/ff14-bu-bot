module Eriones
  class Decorator
    attr_reader :item, :type

    def initialize(item, type:)
      @item = item
      @type = type
    end

    def render
      [
        __send__(:"render_#{type}"),
        "",
        item.eriones_path,
      ].join("\n")
    end

    private

    def render_summary
      lines = []
      exist = []

      lines << "#{item.name}は"

      exist << "ギャザラー情報" if item.gatherers
      exist << "入手情報" if item.markets
      exist << "モンスター情報" if item.monsters
      exist << "ショップ情報" if item.npc_shops
      lines << exist.join(", ")
      lines << "の情報が見つかりました。"

      lines.join("\n")
    end

    def render_gatherer
      lines = []

      lines << "#{item.name}のギャザラー情報は"

      if item.gatherers.nil?
        lines << "みつかりませんでした"
      else
        item.gatherers.each do |g|
          lines << "- クラス: #{g.klass}, LV: #{g.lv}, タイプ: #{g.type}, リージョンエリア: #{g.region_area}, 位置: #{g.position}"
          lines << "- #{g.map_url}"
        end
      end

      lines.join("\n")
    end

    def render_market
      lines = []

      lines << "#{item.name}の入手情報は"

      if item.markets.nil?
        lines << "みつかりませんでした"
      else
        item.markets.each do |m|
          lines << "- 取引情報 #{m.market_information}, 部類: #{m.group}, IL: #{m.il}, 必要アイテム #{m.need_item}, 必要数: #{m.need_amount}"
        end
      end

      lines.join("\n")
    end

    def render_monster
      lines = []

      lines << "#{item.name}のモンスター情報は"

      if item.monsters.nil?
        lines << "みつかりませんでした"
      else
        item.monsters.each do |m|
          lines << "- モンスター名 #{m.name}, エリア: #{m.area}"
        end
      end

      lines.join("\n")
    end

    def render_npc_shop
      lines = []

      lines << "#{item.name}のショップ情報は"

      if item.monsters.nil?
        lines << "みつかりませんでした"
      else
        item.npc_shops.each do |m|
          lines << "- NPC名 #{m.name}, マップ 座標: #{m.map}, 販売価格: #{m.price}"
        end
      end

      lines.join("\n")
    end
  end
end
