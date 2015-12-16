# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#include ActiveRecord  

tablas = %w{ ubicaciongeograficas oficinas cargos Docidens Docidenexts Catalogos Entidads Empresas Monedas Fondos Libroauxiliars Tipocomprobantes Tiposociedads Tipoentidads Origenasientos Grupos Nivels }
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

Oficina.delete_all
open("oficina.txt") do |oficinas|
  oficinas.read.each_line do |oficina|
    code, codigo, nombre, sigla, direccion, telefono, correo, activo, fini, ffin = oficina.chomp.split("|")
    Oficina.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :direccion => direccion, :telefono => telefono, :correo => correo, :activo => activo, :created_at => fini, :updated_at => ffin)
  end
end

Cargo.delete_all
#Cargo.reset_pk_sequence
open("cargo.txt") do |cargos|
  cargos.read.each_line do |cargo|
    codigo, nombre, activo = cargo.chomp.split("|")
    Cargo.create!(:codigo => codigo, :nombre => nombre, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Dociden.delete_all
#Cargo.reset_pk_sequence
open("di.txt") do |dis|
  dis.read.each_line do |di|
    codigo, nombre, mascara, activo = di.chomp.split("|")
    Dociden.create!(:codigo => codigo, :nombre => nombre, :sigla => codigo, :formato => mascara, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Docidenext.delete_all
#Cargo.reset_pk_sequence
open("diex.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, activo = d.chomp.split("|")
    Docidenext.create!(:codigo => codigo, :nombre => nombre, :sigla => codigo, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Grupo.delete_all
#Cargo.reset_pk_sequence
open("grupos.txt") do |ds|
  ds.read.each_line do |d|
    nombre, esbalance, esestresul, naturaleza = d.chomp.split("|")
    Grupo.create!(:nombre => nombre, :esbalance => esbalance, :esestresul => esestresul, :naturaleza => naturaleza, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Nivel.delete_all
#Cargo.reset_pk_sequence
open("nivels.txt") do |ds|
  ds.read.each_line do |d|
    numnivel, nrodigitos, nrodigitostotal, esmoneda, nrodigitosmoneda, nombre, estransaccional, activo = d.chomp.split("|")
    Nivel.create!(:numnivel => numnivel, :nrodigitos => nrodigitos, :nrodigitostotal => nrodigitostotal, :esmoneda => esmoneda, :nrodigitosmoneda => nrodigitosmoneda, :nombre => nombre, :estransaccional => estransaccional, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Tipocomprobante.delete_all
#Cargo.reset_pk_sequence
open("tipocbtes.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, sigla, activo = d.chomp.split("|")
    Tipocomprobante.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Origenasiento.delete_all
#Cargo.reset_pk_sequence
open("origenasie.txt") do |ds|
  ds.read.each_line do |d|
   codigo, nombre, sigla, activo = d.chomp.split("|")
    Origenasiento.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end


Entidad.delete_all
#Cargo.reset_pk_sequence
open("entidad.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, sigla, activo = d.chomp.split("|")
    Entidad.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Empresa.delete_all
#Cargo.reset_pk_sequence
open("empresa.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, sigla, activo = d.chomp.split("|")
    Empresa.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Moneda.delete_all
#Cargo.reset_pk_sequence
open("moneda.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, sigla, esfuncional, esestranjera, esufv, activo = d.chomp.split("|")
    Moneda.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :esfuncional => esfuncional, :esestranjera => esestranjera, :esufv => esufv, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Fondo.delete_all
#Cargo.reset_pk_sequence
open("fondo.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, sigla, activo, entidad, empresa = d.chomp.split("|")
    Fondo.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :activo => activo, :entidad_id => entidad, :empresa_id => empresa, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end



Libroauxiliar.delete_all
#Cargo.reset_pk_sequence
open("libroaux.txt") do |ds|
  ds.read.each_line do |d|
    categoria, descripcion, selista, activo = d.chomp.split("|")
    Libroauxiliar.create!(:categoria => categoria, :descripcion => descripcion, :selista => selista, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end


Tiposociedad.delete_all
#Cargo.reset_pk_sequence
open("TipoAso.txt") do |ds|
  ds.read.each_line do |d|
    sigla, nombre, activo = d.chomp.split("|")
    Tiposociedad.create!(:codigo => '', :nombre => nombre, :sigla => sigla, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Tipoentidad.delete_all
#Cargo.reset_pk_sequence
open("TipoEntidad.txt") do |ds|
  ds.read.each_line do |d|
    sigla, nombre, activo = d.chomp.split("|")
    Tipoentidad.create!(:codigo => '', :nombre => nombre, :sigla => sigla, :activo => activo, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end

Catalogo.delete_all
#Cargo.reset_pk_sequence
open("planctas.txt") do |ds|
  ds.read.each_line do |d|
    codigo, nombre, sigla, padre, estransaccional, esflujodeejec, usalaux1, usalaux2, tlaux1, tlaux2, idctaajustetc, idctaajusteufv, activo, nivel_id, grupo_id, naturaleza, idctaacumajusteufv = d.chomp.split("|")
    Catalogo.create!(:codigo => codigo, :nombre => nombre, :sigla => sigla, :padre => padre, :padre_id => 0, :estransaccional => estransaccional, :esflujodeejec => esflujodeejec, :usalaux1 => usalaux1, :usalaux2 => usalaux2, :tlaux1 => tlaux1, :tlaux2 => tlaux2, :idctaajustetc => idctaajustetc, :idctaajusteufv => idctaajusteufv, :activo => activo, :nivel_id => nivel_id, :grupo_id => grupo_id, :naturaleza => naturaleza, :idctaacumajusteufv => idctaacumajusteufv, :created_at => "2015-05-11 23:33:28", :updated_at => "2015-05-11 23:33:28")
  end
end