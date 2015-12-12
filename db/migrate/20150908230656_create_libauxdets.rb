class CreateLibauxdets < ActiveRecord::Migration
  def change
    create_table :libauxdets do |t|
      t.string :name
      t.references :libauxdetable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :libauxdets, :name
  end
end
