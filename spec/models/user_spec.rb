require 'rails_helper'

RSpec.describe 'User Model Functions', type: :model do
  describe 'Validation test' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'If the user name is an empty string' do
      it 'Validation fails' do
        @user.name = ''
        expect(@user.valid?).to eq(false)
      end
    end

    context 'If the user email address is an empty string' do
      it 'Validation fails' do
        @user.email = ''
        expect(@user.valid?).to eq(false)
      end
    end

    context 'If the user password is an empty string' do
      it 'Validation fails' do
        @user.password = ''
        @user.password_confirmation = '' 
        expect(@user.valid?).to eq(false)
      end
    end

    context 'If the user email address is already in use' do
      it 'Validation fails' do
        user2 = FactoryBot.build(:user, email: @user.email)
        expect(user2.valid?).to eq(false)
      end
    end

    context 'If the user password is less than 6 characters' do
      it 'Validation fails' do
        @user.password = '12345'
        expect(@user.valid?).to eq(false)
      end
    end

    context 'If the user name has a value, the email address is an unused value, and the password is at least 6 characters long' do
      it 'Validation Succeeds in' do
        user2 = FactoryBot.build(:user)
        expect(user2.valid?).to eq(true)
      end
    end
  end
end