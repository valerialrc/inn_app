class AddTotalPriceToActiveReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :active_reservations, :total_price, :decimal, default: 0
  end
end
