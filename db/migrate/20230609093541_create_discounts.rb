class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :item_ids
      t.float :discount
      t.float :discount_amount
      t.integer :discounted_item_id

      t.timestamps
    end
  end
end
