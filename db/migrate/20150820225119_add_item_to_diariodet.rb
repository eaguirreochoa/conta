class AddItemToDiariodet < ActiveRecord::Migration
  def change
    add_column :diariodets, :item, :integer
  end
end
