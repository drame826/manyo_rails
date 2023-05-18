require 'rails_helper'

RSpec.describe 'User Management Functions', type: :system do
  describe 'Registration function' do
    context 'When a user is registered' do
      it 'Transition to the task list screen' do
        visit create_user_path
        fill_in '名前', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'
        sleep(1)
        expect(current_path).to eq tasks_path
      end
    end

    context 'When you move to the Task List screen without logging in' do
      it 'The user is redirected to the login screen and the message "Please log in" is displayed.' do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'Login function' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'When logged in as a registered user' do
      it 'Moves to the Task List screen and displays the message "You are logged in.' do
        visit new_session_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'ログインしました'
      end
    end
  end

  describe 'Administrator function' do
    before do
      @admin_user = FactoryBot.create(:user, name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'メールアドレス', with: 'admin@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end

    context '管理者がWhen the administrator logs inログインした場合' do
      it 'Access to the user list screen' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
      end
  
      it 'Can register administrators' do
        visit new_admin_user_path
        fill_in '名前', with: 'テスト管理者'
        fill_in 'メールアドレス', with: 'admin2@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'
        expect(page).to have_content 'ユーザを登録しました'
        visit admin_users_path
        expect(page).to have_content 'テスト管理者'
      end
  
      it 'Access to user details screen' do
        visit admin_user_path(@user)
        expect(current_path).to eq admin_user_path(@user)
      end
  
      it 'Edit users other than yourself from the user edit screen' do
        other_user = FactoryBot.create(:user)
        visit edit_admin_user_path(other_user)
        expect(current_path).to eq edit_admin_user_path(other_user)
        fill_in '名前', with: '編集後の名前'
        click_button '更新する'
        sleep(1)
        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'ユーザを更新しました'
      end
      it 'Users can be deleted.' do
       
      end
    end
     

    context 'When a general user accesses the User List screen' do
      before do
        visit logout_path
        @user = FactoryBot.create(:user, name: 'user0', email: 'user0@example.com', password: 'password', password_confirmation: 'password', admin: false)
        visit new_session_path
        fill_in 'メールアドレス', with: 'user0@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end

      it 'Moves to the task list screen and displays the error message "Only administrators can access this screen".' do
        visit admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content '管理者以外アクセスできません'
      end
    end
  end
end