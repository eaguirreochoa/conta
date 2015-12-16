class CreateUbicaciongeograficas < ActiveRecord::Migration
  def change
    create_table :ubicaciongeograficas do |t|
      t.string :codigodept
      t.string :codigoprov
      t.string :codigoloca
      t.string :nombredept
      t.string :nombreprov
      t.string :nombreloca
      t.boolean :activo

      t.timestamps null: false
    end
  end
end
