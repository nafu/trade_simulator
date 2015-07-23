require './lib/stock_data_getter'

from = '2011/01/4'
to   = '2011/06/30'
market = :t
sdg = StockDataGetter.new(from, to, market)

(1300..9999).each do |code|
  sdg.get_price_data(code)
end
