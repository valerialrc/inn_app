class CreatePeriodPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :period_prices do |t|
      t.references :room, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :daily_value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
