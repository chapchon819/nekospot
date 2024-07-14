require 'aws-sdk-s3'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://nekospot.jp"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-ap-northeast-1.amazonaws.com/#{ENV['BUCKET_NAME']}"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['BUCKET_NAME'],
  aws_access_key_id: ENV['AWS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECLET_KEY'],
  aws_region: 'ap-northeast-1',
)

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  # トップページ
  add root_path, :priority => 1.0, :changefreq => 'daily'

  # ねこスポット / 口コミ一覧
  add spots_path, :priority => 0.8, :changefreq => 'daily'

  # 猫スポットMap
  add map_spots_path, :priority => 0.9, :changefreq => 'daily'

  # 猫スポット診断
  add start_diagnostics_path, :priority => 0.8, :changefreq => 'monthly'

  # お問い合わせページ
  add 'https://twitter.com/819Chapchon', :priority => 0.5, :changefreq => 'monthly'

  # 利用規約ページ
  add terms_of_use_path, :priority => 0.5, :changefreq => 'yearly'

  # プライバシーポリシーページ
  add privacy_policy_path, :priority => 0.5, :changefreq => 'yearly'
end