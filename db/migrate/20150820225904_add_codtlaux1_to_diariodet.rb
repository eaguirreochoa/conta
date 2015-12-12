class AddCodtlaux1ToDiariodet < ActiveRecord::Migration
  def change
    add_column :diariodets, :codtlaux1, :string
  end
end
