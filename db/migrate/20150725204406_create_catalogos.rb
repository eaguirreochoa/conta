class CreateCatalogos < ActiveRecord::Migration
  def change
    create_table :catalogos do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.integer :padre
      t.boolean :estransaccional
      t.boolean :esflujodeejec
      t.boolean :usalaux1
      t.boolean :usalaux2
      t.string :tlaux1
      t.string :tlaux2
      t.integer :idctaajustetc 
      t.integer :idctaajusteufv
      t.boolean :activo
      t.references :nivel, index: true
      t.references :grupo, index: true

      t.timestamps null: false
    end
    add_foreign_key :catalogos, :nivels
    add_foreign_key :catalogos, :grupos
  end
end
