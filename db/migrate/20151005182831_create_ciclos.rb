class CreateCiclos < ActiveRecord::Migration
  def change
    create_table :ciclos do |t|
      t.datetime :fini
      t.datetime :ffin
      t.boolean :activo
      t.references :empresa, index: true

      t.timestamps null: false
    end
    add_foreign_key :ciclos, :empresas
  end
end
