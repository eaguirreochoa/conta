class AddDescToCierreCiclo < ActiveRecord::Migration
  def change
    add_column :cierre_ciclos, :desc, :string
  end
end
