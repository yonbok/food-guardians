class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.integer :payment, null: false
      t.string :name, null: false
      t.string :postcode, null: false
      t.string :address, null: false
      t.integer :order_status, null: false, default: 0
      t.float :shipping_fee, null: false
      t.timestamps
    end
  end
end
