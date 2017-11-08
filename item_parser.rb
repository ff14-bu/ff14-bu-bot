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
