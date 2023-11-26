class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :score
      t.text :description
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
