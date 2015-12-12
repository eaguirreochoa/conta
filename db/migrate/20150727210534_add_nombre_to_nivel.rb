class AddNombreToNivel < ActiveRecord::Migration
  def change
    add_column :nivels, :nombre, :string
  end
end
