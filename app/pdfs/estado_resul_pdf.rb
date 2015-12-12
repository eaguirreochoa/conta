class EstadoResulPdf < Prawn::Document
	TIPO = {:ING => 'INGRESO', :GAS => 'GASTO', :PAT => 'PATRIMONIO'}
	def initialize(f_ini, f_fin, catalogo_ids, sesion)
		super()
		@f_fin = f_fin.to_date
		@f_ini = f_ini.to_date
		
		@sesion = sesion.to_i
		@sesion = rand(1000) + rand(10)
		
		@catalogo_ids = catalogo_ids

		@total_gasto = 0
		@total_ingreso = 0
		@total_patrimonio = 0

		data
		header
		header_lead
		table_content
		footer			
		#number_pages "Page  of  pages", :at => [bounds.right - 100,0], :page_filter => :all
		#number_pages "<page> in a total of <total>", [bounds.right - 50, 0]
	end

	def data
		@empresa = Empresa.first.nombre
		@c_ut_pe = Catalogo.find_by(id: Catalogo::ID_CTA_UTIL_PER) 

		@sql = "delete from balance_grals where sesion = #{@sesion};"
				ActiveRecord::Base.connection.execute(@sql)
		#inseta el plan de cuentas para ACT PAS GAS ING		
		@sql = "insert into balance_grals (sesion, em_of_c, empresa_id, oficina_id, catalogo_id,  numnivel, padre_id, naturaleza, estransaccional, tipo, saldo, saldob, saldoc, created_at, updated_at)" +
				" SELECT #{@sesion}, (11 || c.id) em_of_c, 1 empresa_id, 1 oficina_id, c.id catalogo_id, n.numnivel, c.padre_id, g.naturaleza, 't', case when g.nombre = 'INGRESO' then 'ING' when  g.nombre = 'GASTO' then 'GAS' when g.nombre = 'PATRIMONIO' then 'PAT' end tipo, 0,0,0, '#{Time.now.to_date}', '#{Time.now.to_date}'"+ 
				" from catalogos c INNER JOIN grupos g on c.activo = 't' and g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id where c.estransaccional = 't' and (g.esestresul = 't' or (g.esbalance = 't' and g.nombre = 'PATRIMONIO'));"
		ActiveRecord::Base.connection.execute(@sql)

		#actualiza debe, haber de las cuentas transaccionales GAS ING PAT
		@sql = "update balance_grals set debe = (select ifnull(SUM(debe),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.em_of_c = balance_grals.em_of_c and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id)," +
									" haber = (select ifnull(SUM(haber),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.em_of_c = balance_grals.em_of_c and a.empresa_id = balance_grals.empresa_id and  a.oficina_id  = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id)" +
				" where balance_grals.sesion = #{@sesion};"	
		ActiveRecord::Base.connection.execute(@sql)

		# #inserta cuenta transaccional de patrimonio 'PAT'(utilidad o perdida del ciclo)
		# @sql = "insert into balance_grals (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tipo, numnivel, padre_id, naturaleza, estransaccional, saldo, saldob, saldoc, created_at, updated_at)" +
		# 	   " select distinct '#{@c_ut_pe.codigo}', #{@sesion}, empresa_id || oficina_id || '#{@c_ut_pe.id}', empresa_id, oficina_id, #{@c_ut_pe.id}, 'PAT' tipo, numnivel, #{@c_ut_pe.padre_id}, '#{@c_ut_pe.naturaleza}', 't', 0 saldo, 0, 0, '#{Time.now.to_date}', '#{Time.now.to_date}'" +
		# 	   " from balance_grals where sesion = #{@sesion};"
		# ActiveRecord::Base.connection.execute(@sql)

		#actuliza saldo de cuentas transaccionales solo ACT GAS PAS ING
		@sql = "update balance_grals set saldo = case when tipo in ('GAS') then (debe - haber) when tipo in('PAT','ING') then (haber - debe) else 0 end " +
		 	  " where balance_grals.sesion = #{@sesion};"
		ActiveRecord::Base.connection.execute(@sql)

		@sql = "update balance_grals set debe = ifnull((select ifnull(SUM(debe) - SUM(haber),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.tipo = 'GAS'),0)," +
									" haber = ifnull((select ifnull(SUM(haber) - SUM(debe),0) from balance_gral_suma_saldos a where a.fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d") }' and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.tipo = 'ING'),0)" +
				" where  catalogo_id = #{@c_ut_pe.id} and tipo = 'PAT' and balance_grals.sesion = #{@sesion};"	
		ActiveRecord::Base.connection.execute(@sql)
		
		@sql = "update balance_grals set saldo = haber - debe" +
		      " where tipo = 'PAT' and balance_grals.sesion = #{@sesion};"	
		ActiveRecord::Base.connection.execute(@sql)

		##para otros ciclos anteriores se recupera de los historicos...
		@ciclos = Ciclo.where(activo: 'f', empresa_id: 1).order(id: :desc).limit(2).pluck(:id)

		BalanceGral.transaction do
			if not (@ciclos[0].blank?)
		  		@sql = "update balance_grals set saldob = ifnull((select case when esdebito = 't' then (debe - haber) when esdebito = 'f' then (haber - debe) else 0 end from mayor_hists a where a.ciclo_id = #{@ciclos[0].to_i} and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id),0)" +
					  " where estransaccional = 't' and balance_grals.sesion = #{@sesion};"
				puts @sql
				ActiveRecord::Base.connection.execute(@sql)			
	    	end
	    	if not (@ciclos[1].blank?)
		  		@sql = "update balance_grals set saldoc = ifnull((select case when esdebito = 't' then (debe - haber) else (haber - debe) end from mayor_hists a where a.ciclo_id = #{@ciclos[1].to_i} and a.empresa_id = balance_grals.empresa_id and a.oficina_id = balance_grals.oficina_id and a.catalogo_id = balance_grals.catalogo_id),0)" +
					  " where balance_grals.sesion = #{@sesion};"
				ActiveRecord::Base.connection.execute(@sql)			
	    	end
    	end
    	#elimina saldos en 0
		@sql = "delete from balance_grals where (saldo = 0 and saldob = 0  and saldoc = 0) and balance_grals.sesion = #{@sesion};"	
		ActiveRecord::Base.connection.execute(@sql)
		
		#inserta padre del la cuenta transaccional
		BalanceGral.transaction do
  			(Nivel.nivel_transac - 1).times do |i|
  				
    			BalanceGral.connection.execute "insert into balance_grals (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tipo, numnivel, padre_id, naturaleza, estransaccional, saldo, saldosec, created_at, updated_at) " +
					"select distinct c.codigo, #{@sesion}, a.empresa_id || a.oficina_id || c.id, a.empresa_id, a.oficina_id, c.id, tipo, n.numnivel, c.padre_id, c.naturaleza, 'f' estransaccional, 0 saldo, 0 saldosec, "+ 
					"'#{Time.now.to_date}', '#{Time.now.to_date}' " +
					" from balance_grals a inner join catalogos c on a.padre_id = c.id and c.activo = 't' inner join grupos g on g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id where a.numnivel > n.numnivel and a.sesion = #{@sesion} and c.activo = 't' and c.estransaccional = 'f' " +
					" and not exists(select 1 from balance_grals x where x.sesion = a.sesion and x.em_of_c = (a.empresa_id || a.oficina_id || c.id) );"
  			end
		end
	
		#actuliza saldos en funcion de las cuentas transaccionales a LOS PADRES
	    BalanceGral.transaction do
  			(Nivel.nivel_transac - 1).times do |i|
    			BalanceGral.connection.execute "update balance_grals set saldo = (select ifnull(sum(saldo),0) saldo from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1),"+
    				" saldob = (select ifnull(sum(saldob),0) saldo from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1),"+
    				" saldoc = (select ifnull(sum(saldoc),0) saldo from balance_grals a where a.sesion = #{@sesion} and a.padre_id= balance_grals.catalogo_id and a.numnivel > balance_grals.numnivel - 1)"+
    				" where balance_grals.estransaccional = 'f' and balance_grals.sesion = #{@sesion};"
  			end
		end
		#inserta totales activo pasico...
		@sql = "insert into balance_grals (codigo, sesion, em_of_c, empresa_id, oficina_id, catalogo_id, tipo, numnivel, padre_id, naturaleza, estransaccional, saldo, saldob, saldoc, created_at, updated_at)" +
			   " select '999999', #{@sesion}, empresa_id || oficina_id || '0', empresa_id, oficina_id, '0' catalogo_id, tipo, #{Nivel.nivel_capitulo}, '', '', 'f', sum(saldo), sum(saldob), sum(saldoc), '#{Time.now.to_date}', '#{Time.now.to_date}'" +
			   " from balance_grals where sesion = #{@sesion} and estransaccional = 't' group by empresa_id, oficina_id, tipo;"
		ActiveRecord::Base.connection.execute(@sql)

		@balance_gral = BalanceGral.where(numnivel: @catalogo_ids, sesion: @sesion).order(:tipo, :codigo)

	end

	def header
		text @empresa, size: 15
		#stroke_color "eeeeee"
		#stroke_line [0, 680], [530, 680]
	end

	def header_lead

		y_position = cursor - 10
		bounding_box([50, y_position], :width => 400, :heigth => 50 ) do
			font_size 15
			text "Estado de Resultados", :align => :center
			move_down 2
			font_size 8
			text "Al: "+ @f_fin.strftime("%d/%m/%Y") , :align => :center, :style => :italic
		    move_down 2
		    font_size 8
			text "(Expresado en Bolivianos)", :align => :center, :style => :italic

		end
		move_down 15
		font_size 10	
					
	end

	def table_content
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
		 	t.column_widths = [300,60,50,50]
		 	t.cells.borders = []
		# 	#row(0).borders = [:bottom]
		 	t.row(0).border_width = 0.5
		 	t.row(0).font_style = :bold
	

			@formato.each do |a|
				t.row(a.to_i).font_style = :bold
			end

		 end
	end

	def line_item_rows		

		nivel_max = 11

		arr = [["","1", "2"]]

		@formato = Array.new

		if not (@ciclos[0].blank?)
			year = @f_fin.year
			yearb = (Ciclo.find_by(id: @ciclos[0].to_i).ffin).year
			arr = [["",year, yearb, ""]]
		else  	
			if not (@ciclos[1].blank?)
				year = @f_fin.year
				yearb = (Ciclo.find_by(id: @ciclos[0].to_i).ffin).year
				yearc = (Ciclo.find_by(id: @ciclos[1].to_i).ffin).year
				arr = [["",year, yearb, yearc]]
			else
				year = @f_fin.year
				arr = [["",year, "", ""]]
			end	
		end
				
		j = 1
		sw = 0
		i = 0
		@balance_gral.where(tipo: ['ING','GAS','PAT'], estransaccional: 'f', sesion: @sesion).map do |det|			
			
			if det.codigo == '999999'		

				if not (@ciclos[0].blank?)
					
						arr << [["TOTAL", TIPO[det.tipo.to_sym]].join(" "), det.saldo.round(2), det.saldob.round(2)] 
				else  	
					if not (@ciclos[1].blank?)
						arr << [["TOTAL", TIPO[det.tipo.to_sym]].join(" "), det.saldo.round(2), det.saldob, det.saldoc.round(2)] 
					else
						arr << [["TOTAL", TIPO[det.tipo.to_sym]].join(" "), det.saldo.round(2)] 
					end
				end

				@formato[i] = j
				i += 1

			else
				if 	det.numnivel == 1 and det.codigo != '999999'
					arr << [{content: [det.catalogo.codigo,det.catalogo.nombre].join(".") }]	
					@formato[i] = j
					i += 1 
				else
					if not (@ciclos[0].blank?)
			  			arr << [{:content => det.catalogo.nombre , :padding => [5,5 ,5, (det.numnivel * 5 )] }, det.saldo.round(2), det.saldob.round(2)]
			    	else  	
			    		if not (@ciclos[1].blank?)
				 			arr << [{:content => det.catalogo.nombre , :padding => [5,5 ,5, (det.numnivel * 5 )] }, det.saldo.round(2), det.saldob.round(2), det.saldoc.round(2)]
				 		else
				 			arr << [{:content => det.catalogo.nombre , :padding => [5,5 ,5, (det.numnivel * 5 )] }, det.saldo.round(2)]
				 		end	
			    	end
				end
			end	

			j += 1		
        
        end #end@formato[1] = j
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
					:at => [480, 15], :style => :italic, :size => 7
	            move_down 5 
	            text "#{i+1}/#{page_count}", :align => :center # escrive el numero de paginas y el total
	        }
        end		
	end

end