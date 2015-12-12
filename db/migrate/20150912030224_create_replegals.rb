class CreateReplegals < ActiveRecord::Migration
  def change
    create_table :replegals do |t|
      t.string :codigo
      t.references :replegalable, polymorphic: true, index: true
      t.references :persona, index: true

      t.timestamps null: false
    end
    add_index :replegals, :codigo
    add_foreign_key :replegals, :personas
  end
end
