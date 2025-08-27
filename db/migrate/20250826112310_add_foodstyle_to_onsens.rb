class AddFoodstyleToOnsens < ActiveRecord::Migration[8.0]
  def change
    add_column :onsens, :foodstyle, :integer
  end
end
