class AddCodtlaux1ToDiariodet < ActiveRecord::Migration
  def change
    add_column :diariodets, :codtlaux1, :integer
  end
end
