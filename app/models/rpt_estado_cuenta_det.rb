class RptEstadoCuentaDet
	include ActiveModel::Model
  	attr_accessor :f_ini, :f_fin, :catalogo_id, :cod_lib_aux1, :sesion
  	validates :f_ini, :f_fin, presence: true  
  	
	def inicio_ciclo
		#return '20150101'.to_date
		return Ciclo.fecha_ini_ciclo(1).to_date
	end

	def fin_periodo
		#return '20150101'.to_date
		return Periodo.fecha_fin_periodo_rpt(1).to_date
	end
end
