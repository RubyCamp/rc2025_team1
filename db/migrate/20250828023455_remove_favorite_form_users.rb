class RemoveFavoriteFormUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :favorite, :string
  end
end
