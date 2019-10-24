class AddExpiresToSession < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :expires, :timestamp
  end
end
