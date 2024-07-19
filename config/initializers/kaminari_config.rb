# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 25
  config.window = 1    # 現在のページの前後に表示するページリンクの数を指定します
  config.outer_window = 1    # 最初と最後のページリンクの数を指定します
  config.left = 0      # 現在のページの左側に表示するページリンクの数を指定します
  config.right = 0     # 現在のページの右側に表示するページリンクの数を指定します
end
