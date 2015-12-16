class CreateMayors < ActiveRecord::Migration
  def change
    create_table :mayors do |t|
      t.integer :sesion
      t.string :em_of_c
      t.datetime :fechacbte
      t.integer :grupo
      t.integer :catalogo_id
      t.integer :empresa_id
      t.integer :oficina_id
      t.integer :moneda_id
      t.string :empresa
      t.string :oficina
      t.string :codigo
      t.string :tipocbte
      t.integer :nrocbte
      t.integer :tlaux1
      t.integer :codtlaux1
      t.integer :tlaux2
      t.integer :codtlaux2
      t.string :glosa
      t.boolean :esdebito
      t.decimal :debe, :precision => 20, :scale => 8
      t.decimal :haber, :precision => 20, :scale => 8
      t.decimal :debesec, :precision => 20, :scale => 8
      t.decimal :habersec, :precision => 20, :scale => 8
      t.decimal :tc, :precision => 20, :scale => 8
      t.decimal :saldo, :precision => 20, :scale => 8
      t.decimal :saldosec, :precision => 20, :scale => 8

      t.timestamps null: false
    end
  end
end
