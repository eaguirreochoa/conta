class Correlcbte < ActiveRecord::Base
  belongs_to :tipocomprobante
  belongs_to :empresa
  belongs_to :periodo 
  belongs_to :diario 

	def self.nro_cbte(idempresa, idtipocbte, fecha)
		idperiodo = Periodo.id_periodo(fecha.to_date, idempresa)
    n = Correlcbte.where(empresa_id: idempresa, tipocomprobante_id: idtipocbte,
                         periodo_id: idperiodo, activo: true ).maximum(:nro)
    	return n.to_i + 1
  	end
end
