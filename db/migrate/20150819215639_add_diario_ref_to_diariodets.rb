class AddDiarioRefToDiariodets < ActiveRecord::Migration
  def change
    add_reference :diariodets, :diario, index: true
    add_foreign_key :diariodets, :diarios
  end
end
