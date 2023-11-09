class AddLegalNameToInns < ActiveRecord::Migration[7.1]
  def change
    add_column :inns, :legal_name, :string
  end
end
