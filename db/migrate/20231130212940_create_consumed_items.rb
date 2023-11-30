class CreateConsumedItems < ActiveRecord::Migration[7.1]
  def change
    create_table :consumed_items do |t|
      t.string :description
      t.decimal :price
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
