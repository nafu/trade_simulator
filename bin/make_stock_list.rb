require './lib/stock_list_maker'

slm = StockListMaker.new(:t)
slm.file_name = ARGV[0] || 'tosho_list.txt'
puts slm.file_name
(1300..9999).each do |code|
  slm.get_stock_info(code)
end
slm.save_stock_list
