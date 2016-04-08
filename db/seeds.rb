# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#include ActiveRecord  

tablas = %w{ ubicaciongeograficas }
tablas.each do |t|
  case ActiveRecord::Base.connection.adapter_name
  when 'SQLite'
    new_max = 0
    update_seq_sql = "update sqlite_sequence set seq = #{new_max} where name = '#{t}';"
    ActiveRecord::Base.connection.execute(update_seq_sql)
  when 'PostgreSQL'
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  else
    raise "Task not implemented for this DB adapter"
  end
end

Ubicaciongeografica.delete_all
open("ubicaciongeografica.txt") do |ubicaciongeograficas|
  ubicaciongeograficas.read.each_line do |ubicaciongeografica|
    code, codigodept, codigoprov, codigoloca, nombredept, nombreprov, nombreloca, fini, ffin = ubicaciongeografica.chomp.split("|")
    Ubicaciongeografica.create!(:codigodept => codigodept, :codigoprov => codigoprov, :codigoloca => codigoloca, :nombredept => nombredept, :nombreprov => nombreprov, :nombreloca => nombreloca, :created_at => fini, :updated_at => ffin, :activo => "1")
  end
end

end
