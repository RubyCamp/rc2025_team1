class AddUseridToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :userid, :string
  end
end
