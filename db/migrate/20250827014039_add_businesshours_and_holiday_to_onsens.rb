class AddBusinesshoursAndHolidayToOnsens < ActiveRecord::Migration[8.0]
  def change
    add_column :onsens, :weekday_hours, :string
    add_column :onsens, :weekend_hours, :string
    add_column :onsens, :holiday, :string
  end
end
