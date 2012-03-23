class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :purchaser_name
      t.integer :quantity
      t.integer :deal_id

      t.timestamps
    end
  end
end
