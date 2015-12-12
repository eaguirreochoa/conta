class AddEsdebitoToDiariodet < ActiveRecord::Migration
  def change
    add_column :diariodets, :esdebito, :boolean
  end
end
