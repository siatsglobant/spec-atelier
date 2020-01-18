class AddOfficeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :office, :string
  end
end
