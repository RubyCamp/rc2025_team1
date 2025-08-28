class AddFavoriteToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :favorite, :string
  end
end
