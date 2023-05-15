class RemoveLabeling < ActiveRecord::Migration[6.0]
  def change
    remove_column :labelings, :created_at, :string
    remove_column :labelings, :updated_at, :string
  end
end
