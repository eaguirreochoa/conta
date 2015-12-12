class Tipocomprobante < ActiveRecord::Base
	def codigoname
    	[self.codigo, self.nombre].join("-")
  	end
end
