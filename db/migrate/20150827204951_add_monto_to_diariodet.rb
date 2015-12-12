class AddMontoToDiariodet < ActiveRecord::Migration
  def change
    add_column :diariodets, :monto, :decimal, :precision => 20, :scale => 8
  end
end