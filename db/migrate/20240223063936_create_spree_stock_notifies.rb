class CreateSpreeStockNotifies < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_stock_notifies do |t|
      t.string :email
      t.references :user, foreign_key: { to_table: :spree_users }, null: false
      t.references :variant, foreign_key: { to_table: :spree_variants }, null: false
      t.boolean :notified, default: false

      t.timestamps
    end
  end
end
