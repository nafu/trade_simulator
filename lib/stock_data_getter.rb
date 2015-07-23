require 'open-uri'
require 'date'

# = StockDatagetter
class StockDataGetter
  attr_accessor :data_dir

  def initialize(from, to, market)
    @from_date = Date.parse(from)
    @to_date   = Date.parse(to)
    @market = market
    @data_dir = 'data'
  end

  def get_price_data(code)
    @code = code
    save_to_file(prices_text)
  end

  def update_price_data(code)
    @code = code
    if File.exist?(data_file_name)
      get_from_date
      append_to_file(prices_text)
    else
      save_to_file(prices_text)
    end
  end

  private

  def prices_text
    prices = get_price_data_from_historical_data_pages
    return if prices.empty?
    prices_to_text(prices)
  end

  def get_price_data_from_historical_data_pages
    page_num = 1
    prices = []
    begin
      url = url_for_historical_data(page_num)
      begin
        text = open(url).read.encode('UTF-8', undef: :replace)
      rescue EOFError
        return []
      end
      prices += text.scan(reg_prices)
      page_num += 1
    end  while text =~ %r{次へ</a></ul>}
    prices
  end

  def url_for_historical_data(page_num)
    'http://info.finance.yahoo.co.jp/history/' \
      "?code=#{@code}.#{@market}" \
      "&sy=#{@from_date.year}" \
      "&sm=#{@from_date.month}&sd=#{@from_date.day}" \
      "&ey=#{@to_date.year}" \
      "&em=#{@to_date.month}&ed=#{@to_date.day}" \
      "&tm=d&p=#{page_num}"
  end

  def reg_prices
    %r!<td>(\d{4}年\d{1,2}月\d{1,2}日)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+)</td><td>((?:\d|,)+(?:\.\d+)?)</td>!
  end

  def prices_to_text(prices)
    new_prices = prices.reverse.map do |price|
      price[0].gsub!(/[年月]/, "\/")
      price[0].gsub!(/日/, '')
      price[0].gsub!(%r{/(\d)/}, '/0\1/')
      price[0].gsub!(%r{/(\d)$}, '/0\1')
      price[1..6].each { |price| price.gsub!(',', '') }
      price.join(',')
    end
    new_prices.join("\n")
  end

  def data_file_name
    "#{@data_dir}/#{@code}.txt"
  end

  def get_from_date
    last_date = File.readlines(data_file_name).last[0..9]
    @from_date = Date.parse(last_date).next
  end

  def save_to_file(prices_text)
    save(prices_text, 'w')
  end

  def append_to_file(prices_text)
    save(prices_text, 'a')
  end

  def save(prices_text, open_mode)
    return unless prices_text
    File.open(data_file_name, open_mode) do |file|
      file.puts prices_text
    end
    puts @code
  end
end
