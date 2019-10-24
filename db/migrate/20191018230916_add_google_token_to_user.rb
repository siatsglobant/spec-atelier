class AddGoogleTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :google_token, :string
    add_column :users, :google_token_refresh, :string
  end
end
