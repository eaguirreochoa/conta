class CierreCiclo < ActiveRecord::Base
  #belongs_to :ciclo
  #belongs_to :diario
  belongs_to :user

  #accepts_nested_attributes_for :diario, allow_destroy: true
  #delegate :tc, to: :diario, prefix: true, allow_nil: true
  before_save :procesar_cierre_ciclo

  validate :val_fecha_cierre_ciclo, on: :create
  after_initialize :set_estado_inicial

  	#set_estado_inicial
  	def set_estado_inicial
    	self.fechaproceso ||= Ciclo.fecha_cierre(1)
    	self.ciclo_id ||= Ciclo.id_ciclo_cierre(1)
    	self.empresa_id ||= 1
    	self.activo ||= true
  	end

  	#definimos metodo virtual para el tc del asiento de apertura
  	def tc
  		@tc = Conta::TCV_CONST 
  	end

	def tc=(value)
  		@tc = value
  	end

  	def val_fecha_cierre_ciclo
  		if self.ciclo_id == 0
  			errors.add(:fechaproceso, "No existen ciclos vigentes.")
  		end

   		#la fecha de proceso tiene que ser igual ala fecha de cierre de ciclo
  		if self.fechaproceso.to_date != Ciclo.fecha_cierre(1).to_date
  			errors.add(:fechaproceso, "La fecha de cierre no corresponde con la fecha programada.")
  		end
  

		if self.esoficial ##el cierre de cilo es oficial => gem asiento de cierre
			#todo los periodos cerrados
			if not(Periodo.todos_los_periodos_cerrados(1, self.ciclo_id))
				errors.add(:fechaproceso, "Existen periodos que no fueron cerrados.")
			end
		end  	 	

		# si ya se aperturo el nuevo ciclo o gestion
  		if not(Ciclo.se_aperturo_new_ciclo(1))
			errors.add(:fechaproceso, "No se aperturo el nuevo ciclo.")
		end
  	end 


    def procesar_cierre_ciclo

	  	sesion = rand(1000) + rand(10)

	    f_ini_ciclo = Ciclo.fecha_ini_ciclo(self.empresa_id).to_date
	    f_fin_ciclo = Ciclo.fecha_fin_ciclo(self.empresa_id).to_date
	   

		cta_utilidad_perdida = Catalogo.find_by(id: Catalogo::ID_CTA_UTIL_PER)

		cta_acum_utilidad_perdida = Catalogo.find_by(id: Catalogo::ID_CTA_UTIL_PER_ACUM)

		@sql = "delete from balance_grals where sesion = #{sesion}"
		ActiveRecord::Base.connection.execute(@sql)

		@sql = "delete from estado_resultados where sesion = #{sesion}"
		ActiveRecord::Base.connection.execute(@sql)

		#inserta saldos de la vista balance_gral_suma_saldos ACT, PAS, ING, GAS
		@sql = "insert into balance_grals (sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, estransaccional, saldo, saldosec, created_at, updated_at) " +
					"select #{sesion}, em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, 't', "+
					"case when tipo in ('ACT') then (debe - haber) when tipo in('PAS','PAT') then (haber - debe) else 0 end  saldo, case when tipo in ('ACT') then (debesec - habersec) when tipo in('PAS','PAT') then (habersec - debesec) else 0 end  saldosec, "+
					"'#{Time.now.to_date}', '#{Time.now.to_date}' " +
					"from (select em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, ifnull(SUM(debe),0) as debe, ifnull(SUM(haber),0) as haber, ifnull(SUM(debesec),0) as debesec, ifnull(SUM(habersec),0) as habersec from saldo_dets where fechacbte between '#{f_ini_ciclo}' and '#{(f_fin_ciclo + 1.day)}' and tipo in('ACT', 'PAS', 'PAT') group by em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza) m; "
					##and tipo in('ACT','PAS') 
		#puts "p1"
		#puts @sql
		ActiveRecord::Base.connection.execute(@sql)

		@sql = "insert into estado_resultados (sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, estransaccional, saldo, saldosec, created_at, updated_at) " +
					"select #{sesion}, em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, 't', "+
					"case when tipo in ('GAS') then (debe - haber) when tipo in('ING') then (haber - debe) else 0 end  saldo, case when tipo in ('GAS') then (debesec - habersec) when tipo in('ING') then (habersec - debesec) else 0 end  saldosec, "+
					"'#{Time.now.to_date}', '#{Time.now.to_date}' " +
					"from (select em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, ifnull(SUM(debe),0) as debe, ifnull(SUM(haber),0) as haber, ifnull(SUM(debesec),0) as debesec, ifnull(SUM(habersec),0) as habersec from saldo_dets where fechacbte between '#{f_ini_ciclo}' and '#{(f_fin_ciclo + 1.day)}' and tipo in('ING', 'GAS') group by em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza) m; "
					##and tipo in('ACT','PAS') 
		#puts "p2"
		#puts @sql
		ActiveRecord::Base.connection.execute(@sql)

		#inserta cuenta transaccional de patrimonio 'PAT' ganancia o perdida de gestion		
		@sql = "insert into estado_resultados (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id,tlaux1, codtlaux1, tipo, numnivel, padre_id, naturaleza, estransaccional, saldo, saldosec, created_at, updated_at) " +
					"select distinct '#{cta_utilidad_perdida.codigo}', #{sesion}, empresa_id || oficina_id || '#{cta_utilidad_perdida.id}', empresa_id, oficina_id, #{cta_utilidad_perdida.id}, tlaux1, codtlaux1, 'PAT' tipo, numnivel, #{cta_utilidad_perdida.padre_id}, '#{cta_utilidad_perdida.naturaleza}', 't', "+
					" 0 saldo, 0 saldosec, '#{Time.now.to_date}', '#{Time.now.to_date}' " +
					"from estado_resultados where sesion = #{sesion} ;"
		#puts "p3"
		#puts @sql
		ActiveRecord::Base.connection.execute(@sql)
		
		@sql = "update estado_resultados set saldo = (select ifnull(sum(saldo),0) saldo from estado_resultados a where a.tipo in('ING') and a.empresa_id = estado_resultados.empresa_id and a.oficina_id = estado_resultados.oficina_id and a.tlaux1 = estado_resultados.tlaux1 and a.codtlaux1 = estado_resultados.codtlaux1 and a.estransaccional = 't' and a.sesion = #{sesion}) - (select ifnull(sum(saldo),0) saldo from estado_resultados a where a.tipo in('GAS') and a.empresa_id = estado_resultados.empresa_id and a.oficina_id = estado_resultados.oficina_id and a.tlaux1 = estado_resultados.tlaux1 and a.codtlaux1 = estado_resultados.codtlaux1 and a.estransaccional = 't' and a.sesion = #{sesion}) "+
		" where tipo = 'PAT' and estado_resultados.sesion = #{sesion};"
		#puts "p4"
		#puts @sql
		ActiveRecord::Base.connection.execute(@sql)

		#actualiza la cuenta acumulada de utilidad o perdida en el balance
		@sql = "update balance_grals set saldo = saldo + (select ifnull(sum(saldo),0) saldo from estado_resultados a where a.catalogo_id = #{cta_utilidad_perdida.id} and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.tlaux1 = balance_grals.tlaux1 and a.codtlaux1 = balance_grals.codtlaux1 and a.sesion = #{sesion}) "+
		" where balance_grals.catalogo_id = #{cta_acum_utilidad_perdida.id} and balance_grals.sesion = #{sesion};"
		#puts "p5"
		#puts @sql
		ActiveRecord::Base.connection.execute(@sql)

	    #graba comprobante de apertura nuevo ciclo
	    @diario_aapertura = Diario.new
	    @diario_aapertura.fechacbte = self.fechaproceso.to_date + 1.day
	    @diario_aapertura.glosagral = 'asiento de apertura'.capitalize
	    @diario_aapertura.esanulado = false
	    @diario_aapertura.estado = 'F'
	    @diario_aapertura.origenasiento_id = 4 #asiento de apertura nuevo ciclo
	    #@diario.tipocomprobante_id = 5 #asiento automatico
	    if self.esoficial
	    	@diario_aapertura.tipocomprobante_id = 3 #asiento traspaso
	    else
	    	puts "entro prliminar"
	    	@diario_aapertura.tipocomprobante_id = 5 #asiento preliminar
	    end
	    @diario_aapertura.empresa_id = 1
	    @diario_aapertura.tc = @tc

	      i = 0
	      asie_apertura = BalanceGral.where(sesion: sesion)
	      asie_apertura.each do |a|
	          i += 1
	          debe = 0
	          haber = 0
	          libaux1 = 0
	          if a.naturaleza == 'D' 
	          	esdebito = true
	          	if a.saldo < 0 
					haber = a.saldo.abs
					debe = 0
	          	else
	          		debe = a.saldo
	          		haber = 0
	          	end
	          else
	          	esdebito = false
				if a.saldo < 0 
					debe = a.saldo.abs
					haber = 0
	          	else
	          		haber = a.saldo
	          		debe = 0
	          	end
	          end
	           if a.codtlaux1 != ''
	          	libaux1 = a.codtlaux1.to_i
	          end
	          puts "entra i esimo detlle "
	          @diario_aapertura.diariodets.build(item:i, catalogo_id: a.catalogo_id, oficina_id: a.oficina_id, moneda_id: 1, libauxdet_id: libaux1, esdebito: esdebito, ajuste: 0, debe: debe, haber: haber, debeori: debe, haberori: haber, debesec: 0, habersec: 0)      
	          
	      end
          puts "antes de grabar cbt"
		  #puts "#{@diario_aapertura}"
		  @diario_aapertura.diariodets.each do |a|
		  	puts "#{a.catalogo_id}"
		  	puts "#{a.moneda_id}"
		  	puts "#{a.debe}"
		  	puts "#{a.haber}"
		  end	
	      @diario_aapertura.save
	      self.diario_id = @diario_aapertura.id

	     if self.esoficial
			#puts "entro es oficial"	
			#graba el asiento de cierre
			@diario_acierre = Diario.new
	    	@diario_acierre.fechacbte = self.fechaproceso.to_date
	    	@diario_acierre.glosagral = 'asiento de cierre'.capitalize
	    	@diario_acierre.esanulado = false
	    	@diario_acierre.estado = 'A'
	    	@diario_acierre.origenasiento_id = 5 #asiento de cierre
	    	@diario_acierre.tipocomprobante_id = 4 #asiento de ajuste
	    	@diario_acierre.empresa_id = 1
	    	@diario_acierre.tc = @tc

	      	i = 0
	      	
	      	asie_apertura = EstadoResultado.where(sesion: sesion)
	      	asie_apertura.each do |a|
	          i += 1
	          aux = 0
	          debe = 0
	          haber = 0
	          libaux1 = 0

	          if a.naturaleza == 'D' 
	          	esdebito = true
	          	if a.saldo < 0 
					haber = a.saldo.abs
					debe = 0
	          	else
	          		debe = a.saldo
	          		haber = 0
	          	end
	          else
	          	esdebito = false
				if a.saldo < 0 
					debe = a.saldo.abs
					haber = 0
	          	else
	          		haber = a.saldo
	          		debe = 0
	          	end
	          end

	          if a.tipo == 'ING' || a.tipo == 'GAS'
	          	aux = debe
	          	debe = haber
	          	haber = aux
	          end
	          if a.codtlaux1 != ''
	          	libaux1 = a.codtlaux1.to_i
	          end
	          @diario_acierre.diariodets.build(item:i, catalogo_id: a.catalogo_id, oficina_id: a.oficina_id, moneda_id: 1, libauxdet_id: libaux1, esdebito: esdebito, ajuste: 0, debe: debe, haber: haber, debeori: debe, haberori: haber, debesec: 0, habersec: 0)
	      	end

	      	@diario_acierre.save
	      	self.iddiariocierre = @diario_acierre.id

	      	Ciclo.find_by(id: self.ciclo_id).update(activo: false)
	      	
			@diario_aapertura.diariodets.each do |a|
				MayorHist.create(empresa_id: self.empresa_id, oficina_id: a.oficina_id, catalogo_id: a.catalogo_id, ciclo_id: self.ciclo_id, periodo_id: 12, tlaux1: a.tlaux1, codtlaux1: a.codtlaux1, esdebito: a.esdebito, tipo: 'BG', debe: a.debe, haber: a.haber, debesec: 0, habersec: 0)      
	      	end

	      	@diario_acierre.diariodets.each do |a|
	      		if a.catalogo.grupo.nombre == 'PATRIMONIO'
	      			MayorHist.create(empresa_id: self.empresa_id, oficina_id: a.oficina_id, catalogo_id: a.catalogo_id, ciclo_id: self.ciclo_id, periodo_id: 12, tlaux1: a.tlaux1, codtlaux1: a.codtlaux1, esdebito: a.esdebito, tipo: 'ER', debe: a.debe, haber: a.haber, debesec: 0, habersec: 0)      
	      		else
					MayorHist.create(empresa_id: self.empresa_id, oficina_id: a.oficina_id, catalogo_id: a.catalogo_id, ciclo_id: self.ciclo_id, periodo_id: 12, tlaux1: a.tlaux1, codtlaux1: a.codtlaux1, esdebito: a.esdebito, tipo: 'ER', debe: a.haber, haber: a.debe, debesec: 0, habersec: 0)      
				end
	      	end
		end
	end    
end
