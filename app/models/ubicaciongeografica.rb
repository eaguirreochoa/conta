class Ubicaciongeografica < ActiveRecord::Base
   has_many :Direccions

   	def departamento
  	  (self.Codigodept || NullUbicaciongeografica.new) rescue NullUbicaciongeografica.Codigodept
	end

	def provincia
  	  (self.Codigoprov || NullUbicaciongeografica.new) rescue NullUbicaciongeografica.Codigoprov
	end
 end
