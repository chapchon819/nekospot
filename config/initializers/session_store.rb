Rails.application.config.session_store :redis_store,
    servers: %w(redis://nekospot-redis-1:6379/0/session),
    # ホスト: docker環境のredisコンテナ名
    # ポート: 6379
    # DB: 0番
    # ネームスペース: session
    expire_after: 90.minutes, # 有効期限90分
    key: "_#{Rails.application.class.module_parent_name.downcase}__session" # キー名