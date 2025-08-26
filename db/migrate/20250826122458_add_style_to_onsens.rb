class AddStyleToOnsens < ActiveRecord::Migration[8.0]
  def change
    add_column :onsens, :style, :integer
  end
end
