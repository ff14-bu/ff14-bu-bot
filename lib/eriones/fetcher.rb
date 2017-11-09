require "net/http"
require "uri"
require "eriones/parsers/item_list_parser"

module Eriones
  module Fetcher
    ERIONES_BASE_URL = 'https://eriones.com'

    class FetcheError < StandardError; end

    def self.list(search_word:)
      query_string = "il=1-275&img=on&i=#{URI.encode_www_form_component(search_word)}"
      uri = URI.parse("#{ERIONES_BASE_URL}/tmp/load/db?#{query_string}")
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
      res = list(search_word: search_word)

      items = Parsers::ItemListParser.new(res.body).items

      item = items.find { |item| item.name == search_word }

      raise FetcheError, "2件以上見つかったよ" if item.nil? && items.count != 1
      
      uri = URI.parse("#{ERIONES_BASE_URL}/#{item.id}")
      request = Net::HTTP::Get.new(uri)
      req_options = {
        use_ssl: uri.scheme == "https",
      }

      res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      res
    end
  end
end
