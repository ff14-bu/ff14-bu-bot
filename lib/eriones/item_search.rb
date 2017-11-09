require "uri"
require "eriones/decorator"
require "eriones/fetcher"
require "eriones/parsers/item_parser"

module Eriones
  class ItemSearch
    attr_reader :keyword

    def self.search(keyword, options = {})
      new(keyword).find(options)
    end

    def initialize(keyword)
      @keyword = keyword
    end

    def find(with:)
      begin
        res = Fetcher.get(search_word: keyword)
      rescue Fetcher::FetcheError => e
        return [
          e.message,
          "#{Fetcher::ERIONES_BASE_URL}/search?i=#{URI.encode_www_form_component(keyword)}",
        ].join("\n\n")
      end

      item = Parsers::ItemParser.new(res.body).item

      if item.id.nil?
        return [
          "#{keyword}はエリオネスでは見つかりませんでした",
          "#{Fetcher::ERIONES_BASE_URL}/search?i=#{URI.encode_www_form_component(keyword)}",
        ].join("\n\n")
      end

      Decorator.new(item, type: with).render
    end
  end
end
