require "eriones/fetcher"

module Eriones
  module Models
    class Item
      attr_accessor :id, :name, :gatherers, :markets, :monsters, :npc_shops, :recipes

      def initialize(attributes)
        attributes.each do |k, v|
          send("#{k.to_s}=", v) if respond_to?("#{k.to_s}=")
        end if attributes
      end

      def eriones_path
        "#{Eriones::Fetcher::ERIONES_BASE_URL}/#{@id}"
      end
    end
  end
end
