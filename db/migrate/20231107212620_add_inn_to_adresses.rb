class AddInnToAdresses < ActiveRecord::Migration[7.1]
  def change
    add_reference :addresses, :inn, foreign_key: true
  end
end
