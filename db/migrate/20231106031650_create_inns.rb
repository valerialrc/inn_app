class CreateInns < ActiveRecord::Migration[7.1]
  def change
    create_table :inns do |t|
      t.references :user, null: false, foreign_key: true
      t.string :trade_name
      t.string :cnpj
      t.string :phone
      t.string :email
      t.string :description
      t.references :payment_methods, null: false, foreign_key: true
      t.boolean :accepts_pets
      t.time :checkin_time
      t.time :checkout_time
      t.string :policies
      t.boolean :active

      t.timestamps
    end
  end
end
