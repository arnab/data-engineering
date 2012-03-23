class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :description
      t.float :price
      t.string :merchant_name
      t.string :merchant_address

      t.timestamps
    end
  end
end
