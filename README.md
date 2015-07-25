# Macでサンプルをとりあえず動かしたい人向け

1. サンプルダウンロード
http://www.panrolling.com/books/gr/gr121.html

2. 更新ファイルを反映

3. Terminalを開いて`cd`と入力してから、サンプルの`trade_simulator`フォルダをドラッグ&ドロップしてEnter

4. Terminalで以下のスクリプトを実行
  ```
  nkf -Sw -Lu --overwrite *.txt **/*.rb
  ack -l 'Windows-31J' --print0 | xargs -0 sed -i '' 's/Windows-31J/UTF-8/g'

  sed -i -e 's/9999/1334/' bin/make_stock_list.rb
  ruby bin/make_stock_list.rb

  sed -i -e 's/9999/1334/' bin/get_price_data.rb
  sed -i -e 's/2011\/06\/30/2015\/06\/30/' bin/get_price_data.rb
  ruby bin/get_price_data.rb

  sed -i -e '13d' bin/simulate.rb
  LF=$'\\\x0A'
  sed -i -e '41a\'$'\n'"$LF" lib/text_to_stock.rb
  sed -i -e '41a\'$'\n''\ \ \ \ section.encode!("UTF-8")' lib/text_to_stock.rb
  sed -i -e '41a\'$'\n'"$LF" lib/text_to_stock.rb
  echo -e "# coding: UTF-8" | cat - setting/estrangement.rb > /tmp/out && mv /tmp/out setting/estrangement.rb
  sed -i -e 's/2012\/12\/28/2015\/06\/30/' setting/estrangement.rb
  sed -i -e 's/readlines(stock_list_file/readlines(stock_list_file, encoding: "UTF-8"/' lib/stock_list_loader.rb
  ruby bin/simulate.rb setting/estrangement.rb
  ```

5. yを押す
