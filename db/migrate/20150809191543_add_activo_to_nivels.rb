class AddActivoToNivels < ActiveRecord::Migration
  def change
    add_column :nivels, :activo, :boolean
  end
end
