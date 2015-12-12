class CreateMonedas < ActiveRecord::Migration
  def change
    create_table :monedas do |t|
      t.string :codigo
      t.string :nombre
      t.string :sigla
      t.boolean :esfuncional
      t.boolean :esestranjera
      t.boolean :esufv
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
