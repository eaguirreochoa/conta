class CreateDireccions < ActiveRecord::Migration
  def change
    create_table :direccions do |t|
      t.string :zonaurbana
      t.string :edificio
      t.string :pisodepof
      t.string :descripcion
      t.references :persona, index: true
      t.references :ubicaciongeografica, index: true

      t.timestamps null: false
    end
    add_foreign_key :direccions, :personas
    add_foreign_key :direccions, :ubicaciongeograficas
  end
end
