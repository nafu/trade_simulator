require './lib/stock_data_getter'

from = '1983/01/4'
to   = '2015/07/24'
market = :t
sdg = StockDataGetter.new(from, to, market)

(1300..9999).each do |code|
  sdg.update_price_data(code)
end
