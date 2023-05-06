require 'rails_helper'

RSpec.describe 'Task Management Functions', type: :system do
  let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline_on: Date.new(2025, 02, 18), priority: :medium, status: :todo, user: user) }
  let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline_on: Date.new(2025, 02, 17), priority: :high, status: :doing, user: user) }
  let!(:task3) { FactoryBot.create(:task, title: 'third_task', deadline_on: Date.new(2025, 02, 16), priority: :low, status: :done, user: user) }

  describe 'Registration Functions' do
    context 'When you register a task' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit new_task_path
        fill_in 'タイトル', with: 'first_task'
        fill_in '内容', with: '企画書を作成する。'
        fill_in'task_deadline_on', with: Date.new(2025, 02, 25)
        select('低', from: 'task_priority')
        select('完了', from: 'task_status')
        click_button '登録する'
      end

      it 'Registered tasks are displayed.' do
        expect(page).to have_content('first_task')
      end
    end
  end

  describe 'List function' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, user: user, title: 'task1', created_at: 3.days.ago) }
    let!(:task2) { FactoryBot.create(:task, user: user, title: 'task2', created_at: 2.days.ago) }
    let!(:task3) { FactoryBot.create(:task, user: user, title: 'task3', created_at: 1.day.ago) }
  
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit tasks_path
    end
  
    context 'When you move to the list screen' do
      it 'The list of created tasks is displayed in descending order of creation date and time.' do
        task_list = all('tbody tr')
  
        expect(task_list[0]).to have_content task3.title
        expect(task_list[1]).to have_content task2.title
        expect(task_list[2]).to have_content task1.title
      end
    end
  
    context 'When a new task is created' do
      let!(:new_task) { FactoryBot.create(:task, title: 'new_task_title', deadline_on: Date.new(2025, 02, 16), priority: :medium, status: :todo, user: user) }
  
      it 'New tasks appear at the top of the list.' do
        visit tasks_path
        expect(page).to have_content new_task.title
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content new_task.title
      end
    end
  end

  describe 'sort function' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit tasks_path
    end

    context 'If you click on the link "Exit Deadline.' do
      it "A list of tasks sorted in ascending order of due date is displayed." do     
        click_on '終了期限'
        sleep(3)
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content task3.title
        expect(task_list[1]).to have_content task2.title
        expect(task_list[2]).to have_content task1.title
      end
    end
      
    context 'If you click on the link "Priority' do
      it "A list of tasks sorted by priority is displayed" do
        click_on '優先度'
        sleep(3)
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content task2.title
        expect(task_list[1]).to have_content task1.title
        expect(task_list[2]).to have_content task3.title
      end
    end
  end
      
  describe 'search function' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, user: user, title: 'first_task', created_at: 3.days.ago) }
    let!(:task2) { FactoryBot.create(:task, user: user, title: 'second_task', created_at: 2.days.ago) }
    let!(:task3) { FactoryBot.create(:task, user: user, title: 'third_task', created_at: 1.day.ago) }
    let!(:task4) { FactoryBot.create(:task, user: user, title: 'forth_task', deadline_on: Date.new(2025, 02, 15), priority: :low, status: :done) }
  
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end
  
    describe 'If you do a fuzzy search on the title' do
      before do
        visit tasks_path
        fill_in 'search_title', with: 'd_task'
        click_button('search_task')
      end
  
      it "Only tasks that contain the search word will be displayed." do
        expect(page).to have_content(task2.title, wait: 10)
        expect(page).to have_content(task3.title, wait: 10)
        expect(page).not_to have_content(task1.title, wait: 10)
        expect(page).not_to have_content(task4.title, wait: 10)
      end
    end
  
    describe 'Search by status' do
      before do
        visit tasks_path
        select('完了', from: 'task_status')
        click_button('search_task')
      end
  
      it "Only tasks matching the searched status will be displayed" do
        expect(page).to have_content(task4.title, wait: 10)
        expect(page).not_to have_content(task1.title, wait: 10)
        expect(page).not_to have_content(task2.title, wait: 10)
        expect(page).not_to have_content(task3.title, wait: 10)
      end
    end
  
    describe 'Search by title and status' do
      before do
        visit tasks_path
        select('完了', from: 'task_status')
        fill_in 'search_title', with: 'th_task'
        click_button('search_task')
      end
  
      it "Only tasks that include the search word in the title and match the status will be displayed" do
        expect(page).not_to have_content(task1.title, wait: 10)
        expect(page).not_to have_content(task2.title, wait: 10)
        expect(page).not_to have_content(task3.title, wait: 10)
        expect(page).to have_content(task4.title, wait: 10)
      end
    end
  end
  
  describe 'Detailed display function' do
    context 'When transitioning to any task detail screen' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        FactoryBot.create(:task, deadline_on: Date.new(2025, 02, 16), priority: :medium, status: :todo, user: user)
        visit tasks_path
        click_on 'search_task'
      end

      it 'The contents of that task are displayed.' do
        expect(page).to have_content 'first_task'
      end
    end
  end
end