class CuentaConfig
	attr_accessor :idcuenta, :es_lista
	def initialize(idcuenta)
		self.idcuenta = idcuenta
		self.es_lista = true
	end

	#retorna el id de moneda de la cuenta contable
	def moneda		
		codigo = Catalogo.find_by(id: idcuenta).codigo
		nivel = Nivel.find_by(esmoneda: true, activo: true )

		nrodigitostotal = nivel.nrodigitostotal
		nrodigitos = nivel.nrodigitos
		codmoneda = codigo.first(nrodigitostotal).last(nrodigitos)

		idmoneda = Moneda.find_by(codigo: codmoneda, activo: true).id
		
    	return idmoneda
	end

	def libro_aux1
		files_set = []
		catalogo = Catalogo.find_by(id: idcuenta)
		if catalogo.usalaux1 then
			return get_json_aux catalogo.tlaux1 
		else
			files_set << {id: 0, name: ""}
			return files_set.as_json
		end		
	end

	def libro_aux2
		catalogo = Catalogo.find_by(id: idcuenta)
		#si usa libro aux 2, se quita el readonly del fiel_text
		if catalogo.usalaux2 then
			return "false" 
		else
			return  "true"
		end
	end

	def tipo_cambio		
		codigo = Catalogo.find_by(id: idcuenta).codigo
		nivel = Nivel.find_by(esmoneda: true, activo: true )

		nrodigitostotal = nivel.nrodigitostotal
		nrodigitos = nivel.nrodigitos
		codmoneda = codigo.first(nrodigitostotal).last(nrodigitos)

		idmoneda = Moneda.find_by(codigo: codmoneda, activo: true).id
		
		if codmoneda == "2" #la cuenta es en dolares
			return Conta::TCC_CONST
		else
			if codmoneda == "1" #la cuenta es en bs
				return  1
			else 
				return  1#otra
			end
		end
 	
	end
	#return en formato json, la lista del libro auxiliar(ptlaux)
	def get_json_aux (ptlaux)	
		nombrelaux = Libroauxiliar.find_by(id:ptlaux).categoria 			
		case nombrelaux
			when "CuentaBanco"
			    return Cuentabanco.select("libauxdets.id, libauxdets.name").joins(:libauxdet).as_json
			when "Fondo"
			  	return Fondo.select('id', 'nombre').where("activo = ?", true ).as_json
			when "Empleado"
			 	return Empleado.select("libauxdets.id, libauxdets.name").joins(:libauxdet).as_json
			when "Oficina"
			  	return Oficina.select('id', 'Nombre as nombre').where("activo = ?", true ).as_json
			when "Proveedor"
			  	return Proveedor.select("libauxdets.id, libauxdets.name").joins(:libauxdet).as_json
			when "Acreedor"
			  	return Acreedor.select("libauxdets.id, libauxdets.name").joins(:libauxdet).as_json
			when "Cliente"
				return Cliente.select("libauxdets.id, libauxdets.name").joins(:libauxdet).as_json
			else
			  puts "no hay libro auxiliar"
		end	
	end
end