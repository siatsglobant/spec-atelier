class AddEngNameAndShowOrderToSection < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :eng_name, :string
    add_column :sections, :show_order, :integer
  end
end
