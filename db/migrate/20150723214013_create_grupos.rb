class CreateGrupos < ActiveRecord::Migration
  def change
    create_table :grupos do |t|
      t.string :nombre
      t.boolean :esbalance
      t.boolean :esestresul
      t.string :naturaleza, limit: 2

      t.timestamps null: false
    end
  end
end
