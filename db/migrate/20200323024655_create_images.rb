class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references  :owner,    polymorphic: true,  null: true
      t.string      :url
      t.string      :kind
      t.integer     :order, default: 0
      t.timestamps
    end

    add_index :images, [:owner_type, :owner_id, :kind], unique: true
  end
end
