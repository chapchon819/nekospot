Rails.application.config.session_store :active_record_store,
    :key => '_my_app_session',
    same_site: :lax, 
    expire_after: 1.week