require 'rails_helper'

RSpec.describe 'OmniauthCallbacks', type: :request do
    describe 'GET /users/auth/google_oauth2/callback' do
        context '1. 新規ユーザーの場合' do
            before do
                mock_auth_hash(:google_oauth2)
                get '/users/auth/google_oauth2/callback'
            end

            it '1) userが新規登録される' do
                expect(User.count).to eq(1)
            end

            it '2) emailが登録される' do
                user = User.first
                expect(user.email).to eq('test@example.com')
            end

            it '3) /spots/mapにリダイレクトされる' do
                expect(response).to redirect_to('/spots/map')
            end
        end

        context '2. 登録済のユーザーの場合' do
            let!(:existing_user) { create(:user, email: 'test@example.com', provider: 'google_oauth2', uid: '123456', password: 'password', password_confirmation: 'password') }

            before do
                mock_auth_hash(:google_oauth2)
                get '/users/auth/google_oauth2/callback'
            end

            it '1) 新たにユーザーデータが作成されない' do
                expect(User.count).to eq(1)
            end

            it '2) 登録済のユーザーでログインする' do
                expect(controller.current_user).to eq(existing_user)
            end

            it '3) /spots/mapにリダイレクトする' do
                expect(response).to redirect_to('/spots/map')
            end
        end

        context '3. ログインに失敗した場合' do
            before do
                mock_auth_failure(:google_oauth2)
                get '/users/auth/google_oauth2/callback'
            end

            it '1) root pathにリダイレクトする' do
                expect(response).to redirect_to(root_path)
            end

            it '2) ユーザーが新規作成されない' do
                expect(User.count).to eq(0)
            end
        end
    end
end