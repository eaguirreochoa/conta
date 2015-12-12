class CreateFondocuentabancos < ActiveRecord::Migration
  def change
    create_table :fondocuentabancos do |t|
      t.boolean :activo
      t.references :cuentabanco, index: true
      t.references :fondo, index: true

      t.timestamps null: false
    end
    add_foreign_key :fondocuentabancos, :cuentabancos
    add_foreign_key :fondocuentabancos, :fondos
  end
end
