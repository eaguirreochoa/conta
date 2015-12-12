class AlterColumnPeriodosNro < ActiveRecord::Migration
   def self.up
    change_table :periodos do |t|
      t.change :nro, :integer
    end
  end
  def self.down
    change_table :periodos do |t|
      t.change :nro, :string
    end
  end
end
