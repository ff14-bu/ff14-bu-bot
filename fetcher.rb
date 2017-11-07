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
