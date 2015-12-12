class CreateBalanceGrals < ActiveRecord::Migration
  def change
    create_table :balance_grals do |t|

      t.integer :sesion
      t.string :em_of_c
      t.integer :empresa_id
      t.integer :oficina_id
      t.integer :catalogo_id
      t.integer :ciclo_id
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
      t.decimal :debe, :precision => 20, :scale => 8
      t.decimal :haber, :precision => 20, :scale => 8
      t.decimal :saldo, :precision => 20, :scale => 8
      t.decimal :saldob, :precision => 20, :scale => 8
      t.decimal :saldoc, :precision => 20, :scale => 8
      t.decimal :debeb, :precision => 20, :scale => 8
      t.decimal :haberb, :precision => 20, :scale => 8
      t.decimal :debec, :precision => 20, :scale => 8
      t.decimal :haberc, :precision => 20, :scale => 8
      t.decimal :debed, :precision => 20, :scale => 8
      t.decimal :haberd, :precision => 20, :scale => 8      
      t.decimal :debesec, :precision => 20, :scale => 8
      t.decimal :habersec, :precision => 20, :scale => 8
      t.decimal :saldosec, :precision => 20, :scale => 8

      t.timestamps null: false
    end
  end
end