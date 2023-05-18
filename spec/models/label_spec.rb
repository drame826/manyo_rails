require 'rails_helper'

RSpec.describe 'Label Model Function', type: :model do
  describe 'Validation test' do
    let(:user) { create(:user) }
    let(:label) { build(:label, user: user) }

    context 'If the label name is an empty string' do
      it 'Validation fails' do
        label.name = ''
        expect(label).not_to be_valid
      end
    end

    context 'If the label name has a value' do
      it 'Validation Succeeds in' do
        expect(label).to be_valid
      end
    end
  end
end