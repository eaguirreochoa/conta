class CreateTipocomprobantes < ActiveRecord::Migration
  def change
    create_table :tipocomprobantes do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
