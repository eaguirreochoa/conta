class AddIdctaacumajusteufvToCatalogos < ActiveRecord::Migration
  def change
    add_column :catalogos, :idctaacumajusteufv, :integer
  end
end
