module Eriones
  module Models
    Gatherer = Struct.new(:klass, :lv, :type, :region_area, :position, :map_url)
    Market = Struct.new(:market_information, :group, :il, :need_item, :need_amount)
    Monster = Struct.new(:name, :area)
    NpcShop = Struct.new(:name, :map, :coordinate, :area_name, :price)
    Recipe = Struct.new(:name, :klass, :lv, :type, :recipe, :crystal)
  end
end
