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
