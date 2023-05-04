class AddUserReference < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :users, null: false, foreign_key: true
  end
end
