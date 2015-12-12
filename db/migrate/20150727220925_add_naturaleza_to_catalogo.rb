class AddNaturalezaToCatalogo < ActiveRecord::Migration
  def change
    add_column :catalogos, :naturaleza, :string, limit: 2
  end
end
