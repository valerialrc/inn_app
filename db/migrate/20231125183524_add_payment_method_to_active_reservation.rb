class AddPaymentMethodToActiveReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :active_reservations, :payment_method, :string
  end
end
