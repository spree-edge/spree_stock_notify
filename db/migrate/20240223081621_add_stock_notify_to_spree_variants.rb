class AddStockNotifyToSpreeVariants < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_variants, :stock_notification, :boolean, default: false
  end
end
