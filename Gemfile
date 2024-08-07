source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Bundle and process CSS
gem 'cssbundling-rails'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# 認証
gem 'devise'
gem "omniauth-google-oauth2"
gem 'omniauth-line'
gem 'omniauth-rails_csrf_protection'

# google_places_api
gem 'google_places'

# javasctipt
gem 'gon'

# debug
gem 'pry-rails'

# Geolocation
gem 'geokit-rails'

# Geocoding
gem 'geocoder'

# Active Hash
gem 'active_hash'

# 検索
gem 'ransack'

# i18n
gem 'rails-i18n', '~> 7.0.0'
gem 'devise-i18n-views'

#画像アップロード
gem 'carrierwave', '~> 3.0'
gem 'carrierwave_backgrounder'
gem "aws-sdk-s3", require: false
gem 'fog-aws'

# ページネーション
gem 'kaminari'

#バックグラウンド処理
gem 'sidekiq'

gem 'faraday'
gem 'faraday-follow_redirects'

# その他
gem 'redis-rails'
gem 'puma_worker_killer'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'factory_bot_rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'rack-mini-profiler', require: false
  gem 'memory_profiler'

  # For call-stack profiling flamegraphs
  gem 'stackprof'
  gem 'flamegraph'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

# security
gem 'dotenv-rails'

#動的OGP
gem 'meta-tags'

#サイトマップ作成
gem 'sitemap_generator', '~> 6.3'


