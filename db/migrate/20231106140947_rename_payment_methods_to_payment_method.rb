class RenamePaymentMethodsToPaymentMethod < ActiveRecord::Migration[7.1]
  def change
    rename_column :inns, :payment_methods_id, :payment_method_id
  end
end
