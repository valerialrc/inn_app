class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.decimal :dimension, precision: 10, scale: 2
      t.integer :max_occupancy
      t.decimal :daily_rate, precision: 10, scale: 2
      t.boolean :has_bathroom
      t.boolean :has_balcony
      t.boolean :has_air_conditioning
      t.boolean :has_tv
      t.boolean :has_wardrobe
      t.boolean :has_safe
      t.boolean :is_accessible
      t.references :inn, null: false, foreign_key: true

      t.timestamps
    end
  end
end
