require './lib/stock'

stock = Stock.new(8604, :t, 100)
puts stock.code
puts stock.market
puts stock.unit

stock.add_price('2011-07-01', 402, 402, 395, 397, 17495700)
stock.add_price('2011-07-04', 402, 404, 400, 403, 18819300)
stock.add_price('2011-07-05', 402, 408, 399, 401, 20678000)
puts stock.prices[0][:date]
puts stock.prices[1][:open]
puts stock.prices[2][:high]
