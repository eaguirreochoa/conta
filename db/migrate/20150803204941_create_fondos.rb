class CreateFondos < ActiveRecord::Migration
  def change
    create_table :fondos do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.boolean :activo
      t.references :entidad, index: true
      t.references :empresa, index: true

      t.timestamps null: false
    end
    add_foreign_key :fondos, :entidads
    add_foreign_key :fondos, :empresas
  end
end
