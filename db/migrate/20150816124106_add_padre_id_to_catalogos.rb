class AddPadreIdToCatalogos < ActiveRecord::Migration
  def change
    add_column :catalogos, :padre_id, :string
  end
end
