class RptDiarioDet
	include ActiveModel::Model
  	attr_accessor :f_ini, :f_fin, :sesion
  	validates :f_ini, :f_fin, presence: true
 	
	def inicio_ciclo
		return Ciclo.fecha_ini_ciclo(1).to_date
	end

	def fin_periodo
		return Periodo.fecha_fin_periodo_rpt(1).to_date
	end

end
