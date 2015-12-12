class CreateEstadoResultados < ActiveRecord::Migration
  def change
    create_table :estado_resultados do |t|

      t.integer :sesion
      t.string :em_of_c
      t.integer :empresa_id
      t.integer :oficina_id
      t.integer :catalogo_id
      t.integer :tlaux1
      t.string :codtlaux1
      t.integer :tlaux2
      t.string :codtlaux2
      t.integer :padre_id
      t.string :codigo	
      t.string :tipo, :limit => 3
      t.integer :numnivel
      t.string :naturaleza, :limit => 2
      t.boolean :estransaccional
      t.decimal :saldo, :precision => 20, :scale => 8
      t.decimal :saldosec, :precision => 20, :scale => 8

      t.timestamps null: false
    end
  end
end
