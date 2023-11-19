class AddTotalPriceToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :total_price, :decimal, default: 0
  end
end
