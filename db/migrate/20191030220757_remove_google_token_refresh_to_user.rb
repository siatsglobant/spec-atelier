class RemoveGoogleTokenRefreshToUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :google_token_refresh, :string
  end
end
