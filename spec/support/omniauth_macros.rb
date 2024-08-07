module OmniauthMacros
    def mock_auth_hash(provider, email: 'test@example.com', uid: '123456', name: 'Test User')
        OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
        provider: provider.to_s,
        uid: uid,
        info: {
            email: email,
            name: name
        },
        credentials: {
            token: 'mock_token',
            refresh_token: 'mock_refresh_token'
        }
        })
    end

    def mock_auth_failure(provider)
        OmniAuth.config.mock_auth[provider] = :invalid_credentials
    end
end

RSpec.configure do |config|
    config.include OmniauthMacros

    config.before(:each) do
        OmniAuth.config.test_mode = true
    end

    config.after(:each) do
        # Clear all OmniAuth mock_auth configurations to ensure a clean state
        OmniAuth.config.mock_auth.clear
    end
end