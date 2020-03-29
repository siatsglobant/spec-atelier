class AddSubitemToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :subitem_id, :integer
  end
end
