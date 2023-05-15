require 'rails_helper'

RSpec.describe 'Label management function', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  describe 'Registration function' do
    context 'When a label is registered' do
      it 'Registered labels are displayed.' do
        visit new_session_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        visit new_label_path
        fill_in '名前', with: 'テストラベル'
        click_button '登録する'
        expect(page).to have_content 'テストラベル'
      end
    end
  end
  
  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered labels is displayed.' do
        visit labels_path
        expect(page).to have_content 'ラベル一覧ページ'
      end
    end
  end
end