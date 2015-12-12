class AddLibauxdetRefToDiariodets < ActiveRecord::Migration
  def change
    add_reference :diariodets, :libauxdet, index: true
    add_foreign_key :diariodets, :libauxdets
  end
end
