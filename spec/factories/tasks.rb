FactoryBot.define do
    # Nommez les données de test à créer "tâche"
    # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
    factory :task do
      title { 'Préparation des documents' }
      content { 'Créer une proposition.' }
    end
    # Nommez les données de test à créer "second_task"
    # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
    factory :second_task, class: Task do
      title { 'Envoyer un e-mail' }
      content { 'Envoyer un e-mail de vente à un client.' }
    end
  end