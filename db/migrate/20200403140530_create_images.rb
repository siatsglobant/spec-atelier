class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references  :owner, polymorphic: true,  null: true
      t.integer     :order, default: 0
      t.string      :url, null: false
      t.string      :name, null: false
      t.timestamps
    end
    add_index(:images, :owner_id)
  end
end
