if Rails.env.production?
Rails.application.config.session_store :redis_store,
    servers: [
    {
        url: ENV['REDIS_URL'],
        namespace: 'session',
        ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
    ],
    expire_after: 90.minutes,
    key: "_#{Rails.application.class.module_parent_name.downcase}_session",
    threadsafe: true,
    secure: Rails.env.production?,
    httponly: true,
    same_site: :lax
else
Rails.application.config.session_store :redis_store,
    servers: %w(redis://nekospot-redis-1:6379/0/session),
    expire_after: 90.minutes,
    key: "_#{Rails.application.class.module_parent_name.downcase}_session",
    threadsafe: true,
    secure: Rails.env.production?,
    httponly: true,
    same_site: :lax
end