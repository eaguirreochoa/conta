class Ajuste < ActiveRecord::Base
  belongs_to :user
  TIPO = {:UFV => "AJUSTE POR UNIDAD DE FOMENTO DE VIVIENDA (UFV)"}
  before_save :procesar_ajuste

  def periodo_a_procesar  	
	fecha_aux = ultimo_periodo_procesado
	fecha_aux = (fecha_aux + 1.day).end_of_month #.strftime("%Y-%m-%d").to_date
  	#fecha_aux = (((fecha + 1.day) + 1.month) -1.day).strftime("%Y-%m-%d").to_date

  	return fecha_aux
  end

  def ultimo_periodo_procesado
	fecha = Ajuste.where(activo: true, empresa_id: 1).maximum(:fechaproceso)
	
	if fecha.blank?
		
		fecha = Periodo.where(activo: true, empresa_id: 1).minimum(:ffin)
		#.end_of_month
		fecha = (fecha.beginning_of_month) - 1.day #).to_date
		#fecha = (fecha - 1.day).strftime("%Y-%m-%d").to_date
	end
	
	return fecha
  end

  def ultimo_indice_procesado
  	ajuste = Ajuste.find_by(fechaproceso: ultimo_periodo_procesado, activo: true)
  	if ajuste.blank?
  		indice_act = "0".to_f
  	else
  		indice_act = ajuste.indiceact
  	end

  	return indice_act
  end

  def procesar_ajuste()
    @sesion = 99
    @f_fin = self.fechaproceso
    @f_ini_ciclo = '20150101'.to_date
    self.empresa_id =1

    @sql = "delete from mayors where sesion = #{@sesion}"
        ActiveRecord::Base.connection.execute(@sql)

    # transacciones  
     @sql = "insert into mayors (sesion, em_of_c, grupo, catalogo_id, empresa_id, oficina_id, tlaux1, codtlaux1, esdebito, debe, haber, saldosec ,created_at, updated_at) " +
          "select sesion, em_of_c, grupo, catalogo_id, empresa_id, oficina_id, tlaux1, codtlaux1, esdebito, case when saldosec < 0 then haber else debe end debe, case when saldosec < 0 then debe else haber end haber, saldosec, '#{Time.now.to_date}', '#{Time.now.to_date}' " +
          "from (select #{@sesion} sesion, em_of_c, 0 grupo, catalogo_id, empresa_id, oficina_id, tlaux1, codtlaux1, esdebito,case when esdebito = 't' and saldo > 0  then saldo when esdebito = 'f' and saldo < 0 then saldo * (-1) else 0 end debe, case when esdebito = 't' and saldo < 0 then saldo * (-1) when esdebito = 'f' and saldo > 0 then saldo else 0 end haber, saldosec " +
          "from (select em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, esdebito, round(((abs(sum(saldo))*(#{self.indiceact}/#{self.indiceant})) - abs(sum(saldo))), 2) saldo, sum(saldo) saldosec from ajuste_ufv_saldos where fechacbte between '#{@f_ini_ciclo}' and '#{(@f_fin + 1).strftime("%Y-%m-%d")}' group by em_of_c, empresa_id, oficina_id, catalogo_id, tlaux1, codtlaux1, esdebito) m "+ 
          " ) xx"
      puts "imprime ajuste_ufv_saldos"     
      puts @sql   
        ActiveRecord::Base.connection.execute(@sql)

      @sql = "insert into mayors (sesion, em_of_c, grupo, catalogo_id, empresa_id, oficina_id, tlaux1, codtlaux1, esdebito, debe, haber, saldosec ,created_at, updated_at) " +
          "select distinct #{@sesion}, em_of_c, 1 grupo, idctaacumajusteufv, empresa_id, oficina_id, tlaux1, codtlaux1, esdebito, haber, debe, saldosec, '#{Time.now.to_date}', '#{Time.now.to_date}' " +
          "from mayors m inner join (select id, idctaacumajusteufv from catalogos where idctaacumajusteufv >=1 and activo = 't') a on a.id = m.catalogo_id where sesion = #{@sesion} ; "

      ActiveRecord::Base.connection.execute(@sql)

      @diario = Diario.new
      @diario.fechacbte = self.fechaproceso.to_date
      @diario.glosagral = TIPO[:UFV]
      @diario.esanulado = false
      @diario.estado = 'F'
      @diario.origenasiento_id = 3
      @diario.tipocomprobante_id = 4 #asiento de ajuste
      @diario.empresa_id = 1
      @diario.tc = 1

      i = 0
      ajustes = Mayor.where(sesion: @sesion).order(:grupo)
      ajustes.each do |a|
          i += 1
          @diario.diariodets.build(item:i, catalogo_id: a.catalogo_id, oficina_id: a.oficina_id, moneda_id: 1, libauxdet_id: a.codtlaux1, esdebito: a.esdebito, ajuste: 0, debe: a.debe, haber: a.haber, debeori: a.debe, haberori: a.haber, debesec: 0, habersec: 0)      
      end

      @diario.save
      
  end

end
