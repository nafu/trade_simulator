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
end
