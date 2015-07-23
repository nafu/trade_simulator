# = Stock
class Stock
  attr_reader :code, :market, :unit, :prices

  def initialize(code, market, unit)
    @code = code
    @market = market
    @unit = unit
    @prices = []
    @price_hash = {}
  end

  # Add daily stock price
  def add_price(date, open, high, low, close, volume)
    @prices << { date: date,
                 open: open,
                 hight: high,
                 low: low,
                 close: close,
                 volume: volume }
  end

  # Get array of date, open, high, low, close, or volume values
  def map_prices(price_name)
    @price_hash[price_name] ||= @prices.map { |price| price[price_name] }
  end

  def dates
    map_prices(:date)
  end

  def open_prices
    map_prices(:open)
  end

  def high_prices
    map_prices(:high)
  end

  def low_prices
    map_prices(:low)
  end

  def close_prices
    map_prices(:close)
  end

  def volumes
    map_prices(:volume)
  end
end
