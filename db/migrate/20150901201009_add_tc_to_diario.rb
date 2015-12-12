class AddTcToDiario < ActiveRecord::Migration
  def change
    add_column :diarios, :tc, :decimal, :precision => 20, :scale => 8
  end
end
