class AddAjusteToDiariodet < ActiveRecord::Migration
  def change
    add_column :diariodets, :ajuste, :string, limit: 2
  end
end
