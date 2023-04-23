require 'rails_helper'

RSpec.describe 'Fonction de modèle de tâche', type: :model do
  describe 'Test de Validation' do
    context 'Si le Title de la tâche est une chaîne vide' do
      it 'Validation échoue' do
        task = Task.create(title: '', content: 'contenu', deadline_on: '2025/5/15', priority: 'medium', status: 'doing')
        expect(task).not_to be_valid
      end
    end

    context 'Si la description de la tâche est vide' do
      it 'Validation échoue' do
        task = Task.create(title: 'titre', content: '', deadline_on: '2025/5/18', priority: 'medium', status: 'doing')
        expect(task).not_to be_valid
      end
    end

    context 'Si le Title et la description de la tâche ont des valeurs' do
      it 'Vous pouvez enregistrer une tâche' do
        task = Task.create(title: 'titre', content: 'contenu', deadline_on: '2025/5/13', priority: 'medium', status: 'doing')
        expect(task).to be_valid
      end
    end
  end
  describe 'search function' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first task', deadline_on: '2025-02-18', priority: 'medium', status: 'todo')  }
    let!(:second_task) { FactoryBot.create(:task, title: 'first task2', deadline_on: '2025-02-17', priority: 'high', status: 'doing') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third task', deadline_on: '2025-02-16', priority: 'low', status: 'done') }

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
        expect(Task.filter_by_status('done')).not_to include(second_task)
        expect(Task.filter_by_status('done')).to include(third_task)
      end
    end
    context 'When ambiguous title and status searches are performed with the scope method' do
      it "Tasks that include the search word in the title and match the status exactly will be narrowed down" do
        expect(Task.search_by_title('first').filter_by_status('todo')).to include(first_task)
        expect(Task.search_by_title('first').filter_by_status('done')).not_to include(second_task)
        expect(Task.search_by_title('first').filter_by_status('todo')).not_to include(third_task)
      end
    end
  end
end