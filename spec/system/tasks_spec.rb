require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        FactoryBot.create(:task)
        visit tasks_path
        expect(page).to have_content 'Préparation des documents'
      end
    end
  end

  describe 'List display function' do
    let!(:first_task) { FactoryBot.create(:task, created_at: '2025-02-18') }
    let!(:second_task) { FactoryBot.create(:task, created_at: '2025-02-17') }
    let!(:third_task) { FactoryBot.create(:task, created_at: '2025-02-16') }

    before do
      visit tasks_path
    end

    context 'When transitioning to the list screen' do
      it 'The list of created tasks is displayed in descending order of creation date and time.' do
        task_list = all('tbody tr')
      end
    end
    context 'When creating a new task' do
      let!(:new_task) { FactoryBot.create(:task, title: 'new_task_title', created_at: '2025-02-19') }

      before do
        visit tasks_path
      end
      it 'New task is displayed at the top' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content('new_task_title')
      end
    end
  end

  describe 'Detailed display function' do
     context 'When transitioned to any task details screen' do
       it 'The content of the task is displayed' do
        FactoryBot.create(:task)
        visit @task
        expect(page).to have_content 'Créer une proposition.'
       end
     end
  end
end