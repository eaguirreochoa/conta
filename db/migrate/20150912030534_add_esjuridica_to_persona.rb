class AddEsjuridicaToPersona < ActiveRecord::Migration
  def change
    add_column :personas, :esjuridica, :boolean
  end
end
