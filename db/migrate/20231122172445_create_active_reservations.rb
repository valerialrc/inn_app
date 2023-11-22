class CreateActiveReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :active_reservations do |t|
      t.datetime :checkin_date
      t.datetime :checkout_date
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
