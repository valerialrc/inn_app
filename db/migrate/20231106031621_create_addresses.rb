class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :number
      t.string :district
      t.string :state
      t.string :city
      t.string :cep

      t.timestamps
    end
  end
end
