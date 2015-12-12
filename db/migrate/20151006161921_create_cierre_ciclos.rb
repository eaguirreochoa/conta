class CreateCierreCiclos < ActiveRecord::Migration
  def change
    create_table :cierre_ciclos do |t|
      t.datetime :fechaproceso
      t.boolean :esoficial
      t.integer :iddiariocierre
      t.boolean :activo
      t.references :ciclo, index: true
      t.references :diario, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :cierre_ciclos, :ciclos
    add_foreign_key :cierre_ciclos, :diarios
    add_foreign_key :cierre_ciclos, :users
  end
end
