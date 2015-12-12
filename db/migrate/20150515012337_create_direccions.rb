class CreateDireccions < ActiveRecord::Migration
  def change
    create_table :direccions do |t|
      t.string :Zonaurbana
      t.string :Edificio
      t.string :Pisodepof
      t.string :Descripcion
      t.references :Persona, index: true
      t.references :Ubicaciongeografica, index: true

      t.timestamps null: false
    end
    add_foreign_key :direccions, :Personas
    add_foreign_key :direccions, :Ubicaciongeograficas
  end
end
