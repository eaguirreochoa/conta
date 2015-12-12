class Empresa < ActiveRecord::Base
	def codigoname
    	[self.codigo, self.nombre].join("-")
  	end
end
