class CreateCuentabancos < ActiveRecord::Migration
  def change
    create_table :cuentabancos do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.string :nrocuenta
      t.string :tipocuenta, limit: 2
      t.boolean :activo
      t.references :moneda, index: true
      t.references :entidad, index: true
      t.references :catalogo, index: true

      t.timestamps null: false
    end
    add_foreign_key :cuentabancos, :monedas
    add_foreign_key :cuentabancos, :entidads
    add_foreign_key :cuentabancos, :catalogos
  end
end
