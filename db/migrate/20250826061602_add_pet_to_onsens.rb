class AddPetToOnsens < ActiveRecord::Migration[8.0]
  def change
    add_column :onsens, :pet, :boolean
  end
end
