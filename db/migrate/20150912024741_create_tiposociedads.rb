class CreateTiposociedads < ActiveRecord::Migration
  def change
    create_table :tiposociedads do |t|
      t.string :codigo
      t.string :sigla
      t.string :nombre
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
