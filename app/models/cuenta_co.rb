class CuentaCo
	attr_accessor :idcuenta
	def initialize(idcuenta)
		self.idcuenta = idcuenta
	end
    #genera la secuencia sugerida para la nueva cuenta a crear, dependiendo del nivel, grupo y antesosor(padre)
	def secuenciasugerida 
        #recupera los hijos del padre de la cuenta a crear       
		hijos = Catalogo.where("padre_id = ? AND activo = ?", idcuenta, true)

        #configuracion del nivel a crear
		idnivel = Catalogo.find_by(id: idcuenta).nivel_id
		nivelh = Nivel.find_by(id: idnivel).numnivel + 1

        nivel = Nivel.find_by(numnivel: nivelh)
        nrodigitos = nivel.nrodigitos
        nrodigitostotal = nivel.nrodigitostotal
        digito = 0
        aux = 0

        hijos.each do |e|
        	aux = e.codigo.last(nrodigitos).to_i
    		if digito < aux
				digito = aux
    		end
    	end
    	digito = digito + 1
    	c =""
    	nrodigitos.times { c = c + "0" }
    	c = c.to_s + digito.to_s 	
  		
        #codigo sugerido
    	return c.last(nrodigitos).to_s
	end
end
