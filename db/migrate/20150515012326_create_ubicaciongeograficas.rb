class CreateUbicaciongeograficas < ActiveRecord::Migration
  def change
    create_table :ubicaciongeograficas do |t|
      t.string :Codigodept
      t.string :Codigoprov
      t.string :Codigoloca
      t.string :Nombredept
      t.string :Nombreprov
      t.string :Nombreloca
      t.boolean :Activo

      t.timestamps null: false
    end
  end
end
