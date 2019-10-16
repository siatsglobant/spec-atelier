class AddActiveToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :active, :boolean, default: true
  end
end
