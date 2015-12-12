class BalGralSumaSaldoPdf < Prawn::Document
	TIPO = {:ACT => 'ACTIVO', :PAS => 'PASIVO', :ING => 'INGRESO', :GAS => 'GASTO', :PAT => 'PATRIMONIO'}
	
	def initialize(f_ini, f_fin, catalogo_ids, sesion)
		super(:page_layout => :landscape)
		@f_fin = f_fin.to_date
		@f_ini = f_ini.to_date
		@f_ini_menos_un_dia = (f_ini.to_date - 1).strftime("%Y-%m-%d").to_date
		@f_ini_es_apertura = false
		
		if Ciclo.exists?(empresa_id: 1, fini: @f_ini.to_date.beginning_of_day)
			@f_ini_es_apertura = true
			@f_ini_ciclo = Ciclo.fecha_ini_ciclo(1).to_date
		else
			#se toma la fecha de inicio de cilo para fecha de saldos
			if Ciclo.where("? between fini and ffin and empresa_id = ?", @f_ini_menos_un_dia.beginning_of_day, 1).present?
				a = Ciclo.where("? between fini and ffin and empresa_id = ?", @f_ini_menos_un_dia.beginning_of_day, 1).pluck(:fini)
				@f_ini_ciclo = a[0].to_date
			end 
		end

		@sesion = sesion.to_i
		
		@catalogo_ids = catalogo_ids

		@total_activo = 0
		@total_pasivo = 0
		@total_patrimonio = 0

		data
		header
		header_lead
		table_content
		footer			

	end

	def data
		@empresa = Empresa.first.nombre
		@c_ut_pe = Catalogo.find_by(id: Catalogo::ID_CTA_UTIL_PER) 

		@sql = "delete from balance_grals where sesion = #{@sesion};"
		ActiveRecord::Base.connection.execute(@sql)

		#inserta el plan de cuentas para ACT PAS GAS ING		
		@sql = "insert into balance_grals (sesion, em_of_c, empresa_id, oficina_id, catalogo_id,  numnivel, padre_id, naturaleza, estransaccional, tipo, debe, haber, debeb, haberb, debec, haberc, debed, haberd, created_at, updated_at)" +
				" SELECT #{@sesion}, (11 || c.id) em_of_c, 1 empresa_id, 1 oficina_id, c.id catalogo_id, n.numnivel, c.padre_id, g.naturaleza, 't', case when g.nombre = 'ACTIVO' then 'ACT' when g.nombre = 'PASIVO' then 'PAS' when g.nombre = 'PATRIMONIO' then 'PAT' when g.nombre = 'INGRESO' then 'ING' when  g.nombre = 'GASTO' then 'GAS' end tipo, 0,0,0,0,0,0,0,0, '#{Time.now.to_date}', '#{Time.now.to_date}'"+ 
				" from catalogos c INNER JOIN grupos g on c.activo = 't' and g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id where c.estransaccional = 't' and (g.esbalance = 't' or g.esestresul = 't') ;"
		ActiveRecord::Base.connection.execute(@sql)

		if @f_ini_es_apertura			

			#actualiza columna de movimiento, 
			@sql = "update balance_grals set debeb = (select ifnull(SUM(debe),0) from mayor_detalles a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id and origenasiento_id != 4)," +
									" haberb = (select ifnull(SUM(haber),0) from mayor_detalles a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id and origenasiento_id != 4)" +
				" where balance_grals.sesion = #{@sesion};"	
			ActiveRecord::Base.connection.execute(@sql)

			#actualiza columna de saldos,
			@sql = "update balance_grals set debe = (select ifnull(SUM(debe),0) from mayor_detalles a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id and origenasiento_id = 4)," +
									" haber = (select ifnull(SUM(haber),0) from mayor_detalles a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id and origenasiento_id = 4)" +
				" where balance_grals.sesion = #{@sesion};"	
			ActiveRecord::Base.connection.execute(@sql)

		else

			#actualiza columna de movimiento, 
			@sql = "update balance_grals set debeb = (select ifnull(SUM(debe),0) from mayor_detalles a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id)," +
									" haberb = (select ifnull(SUM(haber),0) from mayor_detalles a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id)" +
				" where balance_grals.sesion = #{@sesion};"	
			ActiveRecord::Base.connection.execute(@sql)
			
			#SALDO INICIALES + ASIENTO DE APERTURA
		    @sql = "update balance_grals set debe = (select ifnull(SUM(debe),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini_ciclo}' and '#{(@f_ini_menos_un_dia + 1).strftime("%Y-%m-%d")}' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id)," +
									" haber = (select ifnull(SUM(haber),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini_ciclo}' and '#{(@f_ini_menos_un_dia + 1).strftime("%Y-%m-%d")}' and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id)" +
				" where balance_grals.sesion = #{@sesion};"	
			ActiveRecord::Base.connection.execute(@sql)
		end

		# #inserta cuenta transaccional de patrimonio 'PAT'(utilidad o perdida del ciclo)
		# @sql = "insert into balance_grals (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tipo, numnivel, padre_id, naturaleza, estransaccional, debe, haber, debeb, haberb, created_at, updated_at)" +
		# 	   " select distinct '#{@c_ut_pe.codigo}', #{@sesion}, empresa_id || oficina_id || '#{@c_ut_pe.id}', empresa_id, oficina_id, #{@c_ut_pe.id}, 'PAT' tipo, numnivel, #{@c_ut_pe.padre_id}, '#{@c_ut_pe.naturaleza}', 't', 0, 0, 0, 0, '#{Time.now.to_date}', '#{Time.now.to_date}'" +
		# 	   " from balance_grals where sesion = #{@sesion};"
		# ActiveRecord::Base.connection.execute(@sql)

		#actualiza cuenta de utilidad o perdida de la gestion
		@sql = "update balance_grals set debeb = ifnull((select ifnull(SUM(debe) - SUM(haber),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini_ciclo}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.tipo = 'GAS'),0)," +
									" haberb = ifnull((select ifnull(SUM(haber) - SUM(debe),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini_ciclo}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.tipo = 'ING'),0)" +
				" where catalogo_id = #{@c_ut_pe.id} and tipo = 'PAT' and balance_grals.sesion = #{@sesion};"	
		ActiveRecord::Base.connection.execute(@sql)
		
		
    	#elimina saldos en 0
		@sql = "delete from balance_grals where (debe = 0 and haber = 0  and debeb = 0 and haberb = 0) and balance_grals.sesion = #{@sesion};"	
		ActiveRecord::Base.connection.execute(@sql)
		
		
		#inserta padre del la cuenta transaccional
		BalanceGral.transaction do
  			(Nivel.nivel_transac - 1).times do |i|
  				
    			BalanceGral.connection.execute "insert into balance_grals (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tipo, numnivel, padre_id, naturaleza, estransaccional, debe, haber, debeb, haberb, created_at, updated_at) " +
					"select distinct c.codigo, #{@sesion}, a.empresa_id || a.oficina_id || c.id, a.empresa_id, a.oficina_id, c.id, tipo, n.numnivel, c.padre_id, c.naturaleza, 'f' estransaccional, 0,0,0,0, "+ 
					"'#{Time.now.to_date}', '#{Time.now.to_date}' " +
					" from balance_grals a inner join catalogos c on a.padre_id = c.id and c.activo = 't' inner join grupos g on g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id where a.numnivel > n.numnivel and a.sesion = #{@sesion} and c.activo = 't' and c.estransaccional = 'f' " +
					" and not exists(select 1 from balance_grals x where x.sesion = a.sesion and x.em_of_c = (a.empresa_id || a.oficina_id || c.id) );"
  			end
		end
	
		#actuliza saldos en funcion de las cuentas transaccionales a LOS PADRES
	    BalanceGral.transaction do
  			(Nivel.nivel_transac - 1).times do |i|
    			BalanceGral.connection.execute "update balance_grals set debe = (select ifnull(sum(debe),0) debe from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1),"+
    				" haber = (select ifnull(sum(haber),0) haber from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1),"+
    				" debeb = (select ifnull(sum(debeb),0) debeb from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1),"+
    				" haberb = (select ifnull(sum(haberb),0) haberc from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1)"+
    				" where balance_grals.estransaccional = 'f' and balance_grals.sesion = #{@sesion};"
  			end
		end
		#inserta totales activo pasico...
		@sql = "insert into balance_grals (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tipo, numnivel, padre_id, naturaleza, estransaccional, debe, haber, debeb, haberb, created_at, updated_at)" +
			   " select '999999', #{@sesion}, empresa_id || oficina_id || '0', empresa_id, oficina_id, '0' catalogo_id, tipo, #{Nivel.nivel_capitulo}, '', naturaleza, 'f', sum(debe), sum(haber), sum(debeb), sum(haberb), '#{Time.now.to_date}', '#{Time.now.to_date}'" +
			   " from balance_grals where sesion = #{@sesion} and estransaccional = 't' group by empresa_id, oficina_id, tipo, naturaleza;"
		ActiveRecord::Base.connection.execute(@sql)

		@sql = "update balance_grals set debec = debe + debeb,"+
    				" haberc = haber + haberb"+
    				" where balance_grals.estransaccional = 'f' and balance_grals.sesion = #{@sesion};"
    	ActiveRecord::Base.connection.execute(@sql)

    	@sql = "update balance_grals set debed = case when naturaleza = 'D' and (debec - haberc) > 0  then debec - haberc when naturaleza = 'A' and (haberc - debec) < 0 then (debec - haberc) else 0 end,"+
    				" haberd = case when naturaleza = 'A' and (haberc - debec) > 0 then haberc - debec when naturaleza = 'D' and (debec - haberc) < 0 then haberc - debec else 0 end"+
    				" where balance_grals.estransaccional = 'f' and balance_grals.sesion = #{@sesion};"
    	ActiveRecord::Base.connection.execute(@sql)

		@balance_gral = BalanceGral.where(numnivel: @catalogo_ids, sesion: @sesion).order(:tipo, :codigo)


	end

	def header
		text @empresa, size: 15
		#stroke_color "eeeeee"
		#stroke_line [0, 680], [530, 680]
	end

	def header_lead

		y_position = cursor - 15
		bounding_box([160, y_position], :width => 400, :heigth => 50 ) do
			font_size 15
			text "Balance de Sumas y Saldos", :align => :center
			move_down 2
		    font_size 8
			text "De: "+ @f_ini.strftime("%d/%m/%Y") +" Al: "+ @f_fin.strftime("%d/%m/%Y") , :align => :center, :style => :italic
		    move_down 2
		    font_size 8
			text "(Expresado en Bolivianos)", :align => :center, :style => :italic

			
		end
		move_down 15
		#draw_text @sesion, :at => [3, cursor], :size => 12	
		font_size 8	
					
	end

	def table_content
		# #table [[1, 2],[3, 4]]
		table (line_item_rows) do |t|
		# 	# #cells.padding = 8
		# 	# cells.borders = [:bottom]
		# 	# cells.border_width = 0.5

		# 	# row(0).border_width = 1.5
		# 	# row(-2).border_width = 1.5
		# 	# #row(-1).background_color = "f0ad4e"
		# 	# row(-1).borders = []


		# 	# self.header = true
		# 	#self.row_colors = ['dddddd', 'ffffff']
		 	#t.column_widths = [15,30,30,30,30,50,50,50,50,50,50]
		 	#t.column_widths = [1,1,1,1,1,50,50,50,50,50,50]
		 	#t.column_widths = [5,5,5,5,5,5,5,5,5,5,5,5]
		 	t.column_widths = [160,70,70,70,70,70,70,70,70]
		 	t.cells.borders = []
		# 	#row(0).borders = [:bottom]
		 	t.row(0).border_width = 0.5
		 	t.row(0).font_style = :bold
		 	t.row(1).font_style = :bold
		 	t.row(0).borders = [:bottom, :top, :left, :right]
		 	t.row(1).borders = [:bottom, :top, :left, :right]
			#t.row(2).columns(1..6).style(:align => :right)
			t.columns(1..8).style(:align => :right)
			t.row(0).style(:align => :center)
			@formato.each do |a|
				t.row(a.to_i).font_style = :bold
			end

		 end
	end

	def line_item_rows

		arr = [[{:content => "Cuenta", rowspan: 2}, {:content => "Saldo Inicial", :colspan => 2}, {:content => "Mov. del Periodo", :colspan => 2},{:content => "Balance de Sumas", :colspan => 2}, {:content => "Balance de Saldos", :colspan => 2}],["D", "H","Debe","Haber","Debe", "Haber","Deudor","Acreedor"]]

		@formato = Array.new

						
		j = 2
		
		i = 0

		@balance_gral.where(tipo: ['ACT','PAS','PAT','ING', 'GAS'], estransaccional: 'f', sesion: @sesion).map do |det|			

			if det.codigo == '999999'		

				arr << [["TOTAL", TIPO[det.tipo.to_sym]].join(" "), det.debe.round(2), det.haber.round(2), det.debeb.round(2), det.haberb.round(2), det.debec.round(2), det.haberc.round(2), det.debed.round(2), det.haberd.round(2)] 
		
				@formato[i] = j
				i += 1

			else
				if 	det.numnivel == 1 and det.codigo != '999999'
					arr << [{content: [det.catalogo.codigo,det.catalogo.nombre].join(".") }]	
					@formato[i] = j
					i += 1 
				else
					#{:content => det.catalogo.nombre , :padding => [5,5 ,5, (det.numnivel * 5 )] }
					arr << [det.catalogo.nombre, det.debe.round(2), det.haber.round(2), det.debeb.round(2), det.haberb.round(2), det.debec.round(2), det.haberc.round(2), det.debed.round(2), det.haberd.round(2)]
					
			
				end
			end	

			j += 1		
        
        	end 
        return arr

	end

	def footer

		page_count.times do |i|
	        bounding_box([bounds.left, bounds.bottom], :width => bounds.width, :height => 30) {
	        # por cada pagina, cuenta el numero de pagina 
	        go_to_page i+1
	        	draw_text Time.now.strftime("Printed on %d/%m/%Y") ,
					:at => [1, 15], :style => :italic, :size => 7
				draw_text Time.now.strftime("at %I:%M%p") ,
					:at => [75, 15], :style => :italic, :size => 7
				draw_text "by " + "eaguirre",
					:at => [640, 15], :style => :italic, :size => 7
	            move_down 5 
	            text "#{i+1}/#{page_count}", :align => :center # escrive el numero de paginas y el total
	        }
        end		
	end

end