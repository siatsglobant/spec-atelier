class CreateFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :files do |t|
      t.references  :owner, polymorphic: true,  null: true
      t.integer     :order, default: 0
      t.string      :url, null: false
      t.string      :name, null: false
      t.string      :type, null: false
      t.timestamps
    end
  end
end
