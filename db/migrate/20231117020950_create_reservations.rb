class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :checkin_date
      t.date :checkout_date
      t.integer :guests_number
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
