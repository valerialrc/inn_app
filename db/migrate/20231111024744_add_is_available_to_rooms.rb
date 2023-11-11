class AddIsAvailableToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :is_available, :boolean
  end
end
