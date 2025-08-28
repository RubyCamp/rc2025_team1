class AddParkingToOnsens < ActiveRecord::Migration[8.0]
  def change
    add_column :onsens, :parking, :integer
  end
end
