class AddDiarioRefToCorrelcbtes < ActiveRecord::Migration
  def change
    add_reference :correlcbtes, :diario, index: true
    add_foreign_key :correlcbtes, :diarios
  end
end
