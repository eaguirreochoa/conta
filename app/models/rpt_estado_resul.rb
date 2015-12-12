class RptEstadoResul
	include ActiveModel::Model
  	attr_accessor :f_ini, :f_fin, :catalogo_ids, :sesion
  	validates :f_ini, :f_fin, presence: true
 	
 # 	def initialize()
	# # 	super()
	#  	self.f_ini = '20150101'.to_date
	#  	#Time.now.strftime("%Y-%m-%d")
	# end

	def inicio_ciclo
		#return '20150101'.to_date
		return Ciclo.fecha_ini_ciclo(1).to_date
	end

	def fin_periodo
		#return '20150101'.to_date
		return Periodo.fecha_fin_periodo_rpt(1).to_date
	end

	#@f_ini = '20150101'.to_date
end
