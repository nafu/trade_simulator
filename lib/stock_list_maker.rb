require 'open-uri'

# = StockListMaker
class StockListMaker
  attr_accessor :data_dir, :file_name

  def initialize(market)
    @market = market
    @data_dir = 'data'
    @stock_info = []
  end

  def get_stock_info(code)
    page = open_page(code)
    return unless page
    text = page.read.encode('UTF-8', undef: :replace)
    data = parse(text)
    data[:code] = code
    return unless data[:market_section]
    puts code
    @stock_info << data
  end

  def save_stock_list
    File.open(@data_dir + '/' + @file_name, 'w') do |file|
      @stock_info.each do |data|
        file.puts [data[:code], data[:market_section], data[:unit]].join(',')
      end
    end
  end

  private

  def open_page(code)
    open(
      "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{code}.#{@market}"
    )
  rescue OpenURI::HTTPError
    return
  end

  def parse(text)
    data = {}
    sections = []
    text.lines do |line|
      sections, data = get_market_and_unit(line, sections, data)
      return data if data[:market_section]
    end
    data
  end

  def get_market_and_unit(line, sections, data)
    if line =~ reg_market
      sections << $+
    elsif line =~ reg_unit
      data[:market_section] = sections[0]
      data[:unit] = get_unit($+)
    end
    [sections, data]
  end

  def reg_market
    /"stockMainTabName">([^< ]+)</
  end

  def reg_unit
    %r{<dd class="ymuiEditLink mar0"><strong>((?:\d|,)+|---)</strong>株</dd>}
  end

  def get_unit(str)
    if str == '---'
      '1'
    else
      str.gsub(/,/, '')
    end
  end
end
