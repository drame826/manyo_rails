require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  describe 'Validation testing' do
    context 'If the task title is blank' do
      it 'Validation fails' do
        task = Task.create(title: '', content: '企画書を作成する。', deadline_on: '2025/5/25', priority: 'medium', status: 'doing')
        expect(task).not_to be_valid
      end
    end

    context 'If the task description is empty' do
      it 'Validation fails' do
        task = Task.create(title: '書類作成', content: '', deadline_on: '2025/5/25', priority: 'medium', status: 'doing')
        expect(task).not_to be_valid
      end
    end

    context 'If the task title and description contain values' do
      it 'Tasks can be registered' do
        task = Task.create(title: '書類作成', content: '企画書を作成する。', deadline_on: '2025/5/25', priority: 'medium', status: 'doing', user: @user)
        expect(task).to be_valid
      end
    end
  end

  describe 'search function' do
    let!(:first_task) { FactoryBot.create(:first_task, title: 'first_write_task', user: @user) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "first_call_task", user: @user) }
    let!(:third_task) { FactoryBot.create(:third_task, title: "second_write_task", user: @user) }
    context 'If you do an ambiguous search for a title using the scope method' do
      it "Tasks containing search words are narrowed down." do
        expect(Task.search_by_title('first')).to include(first_task)
        expect(Task.search_by_title('first')).to include(second_task)
        expect(Task.search_by_title('first')).not_to include(third_task)
        expect(Task.search_by_title('first').count).to eq 2
      end
    end
  
    context 'When a status search is performed with the scope method' do
      it "Tasks matching the status exactly are narrowed down." do
        expect(Task.filter_by_status('todo')).to include(first_task)
        expect(Task.filter_by_status('todo')).not_to include(second_task)
        expect(Task.filter_by_status('todo')).to include(third_task)
        expect(Task.filter_by_status('todo').count).to eq 2
      end
    end
      
    context 'When ambiguous title and status searches are performed with the scope method' do
      it "Tasks that include the search word in the title and match the status exactly will be narrowed down." do
        expect(Task.search_by_title('first').filter_by_status('todo')).to include(first_task)
        expect(Task.search_by_title('first').filter_by_status('todo')).not_to include(second_task)
        expect(Task.search_by_title('first').filter_by_status('todo')).not_to include(third_task)
        expect(Task.search_by_title('first').filter_by_status('todo').count).to eq 1
      end
    end
  end
end