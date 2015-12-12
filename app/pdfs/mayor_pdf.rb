class MayorPdf < Prawn::Document
	
	def initialize(f_ini, f_fin, sesion)
		#super(:page_layout => :landscape)
		super()
		@f_fin = f_fin.to_date
		@f_ini = f_ini.to_date
		@f_ini_menos_un_dia = (f_ini.to_date - 1).strftime("%Y-%m-%d").to_date
		@f_ini_es_apertura = false

		#si la f ini es igual a la apertura el asiento de apertura se carga en saldos
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
		data
		#header
		#header_lead
		#table_content
		#footer			
	end

	def data		

		@sql = "delete from mayors where sesion =#{@sesion}"
				ActiveRecord::Base.connection.execute(@sql)

		if @f_ini_es_apertura
			#inseta el detalle menos el asiento de apertura
			@sql = "insert into mayors (sesion, em_of_c, grupo, fechacbte, catalogo_id, empresa_id, oficina_id, moneda_id, empresa, oficina, codigo, tipocbte, nrocbte, tlaux1, codtlaux1, tlaux2, codtlaux2, glosa, esdebito, debe, haber, debesec, habersec, tc, saldo, saldosec, created_at, updated_at) " +
					"select #{@sesion}, em_of_c, 1, fechacbte, catalogo_id, empresa_id, oficina_id, moneda_id, empresa, oficina, codigo, tipocbte, nrocbte, tlaux1, codtlaux1, tlaux2, codtlaux2, glosagral, esdebito, debe, haber, debesec, habersec, tc, 0, 0, '#{Time.now.to_date}', '#{Time.now.to_date}' " +
					"from mayor_detalles where fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d")}' and origenasiento_id != 4; "
	
			ActiveRecord::Base.connection.execute(@sql)
			#SALDO INICIALES + ASIENTO DE APERTURA
		 	@sql = "insert into mayors (sesion, em_of_c, grupo, fechacbte, catalogo_id, empresa_id, oficina_id, codigo, glosa, esdebito, saldo, saldosec, created_at, updated_at)" +
					" select sesion, em_of_c, grupo, '#{@f_ini_menos_un_dia}', catalogo_id, empresa_id, oficina_id, codigo, 'Saldo Inicial' glosa, esdebito, sum(saldo), sum(saldosec), '#{Time.now.to_date}', '#{Time.now.to_date}'" +
					" from(" +
					" select #{@sesion} sesion, em_of_c, 0 grupo, catalogo_id, empresa_id, oficina_id, codigo,'Saldo Inicial' glosa, esdebito, case when esdebito = 't' then debe - haber else haber - debe end saldo, 0 saldosec" +
					" from mayor_detalles where fechacbte between '#{@f_ini}' and '#{(@f_ini + 1).strftime("%Y-%m-%d")}' and origenasiento_id = 4)" +
					" group by sesion, em_of_c, grupo, catalogo_id, empresa_id, oficina_id, codigo, esdebito;"
			#puts @sql
		    ActiveRecord::Base.connection.execute(@sql)		

		else
			#inseta el detalle
			@sql = "insert into mayors (sesion, em_of_c, grupo, fechacbte, catalogo_id, empresa_id, oficina_id, moneda_id, empresa, oficina, codigo, tipocbte, nrocbte, tlaux1, codtlaux1, tlaux2, codtlaux2, glosa, esdebito, debe, haber, debesec, habersec, tc, saldo, saldosec, created_at, updated_at)" +
					" select #{@sesion}, em_of_c, 1, fechacbte, catalogo_id, empresa_id, oficina_id, moneda_id, empresa, oficina, codigo, tipocbte, nrocbte, tlaux1, codtlaux1, tlaux2, codtlaux2, glosagral, esdebito, debe, haber, debesec, habersec, tc, 0, 0, '#{Time.now.to_date}', '#{Time.now.to_date}'" +
					" from mayor_detalles where fechacbte between '#{@f_ini}' and '#{(@f_fin + 1).strftime("%Y-%m-%d")}';"
	
			ActiveRecord::Base.connection.execute(@sql)

			#SALDO INICIALES + ASIENTO DE APERTURA
			@sql = "insert into mayors (sesion, em_of_c, grupo, fechacbte, catalogo_id, empresa_id, oficina_id, codigo, esdebito, glosa, saldo, saldosec, created_at, updated_at)" +
					" select  #{@sesion} sesion, em_of_c, 0, '#{@f_ini_menos_un_dia}', catalogo_id, empresa_id, oficina_id, codigo, case when naturaleza = 'D' then 't' else 'f' end esdebito, 'Saldo Inicial', sum(saldo), 0, '#{Time.now.to_date}', '#{Time.now.to_date}'"+
					" from mayor_saldos" +
					" inner join catalogos c on c.id = catalogo_id" +
					" where fechacbte between '#{@f_ini_ciclo}' and '#{(@f_ini_menos_un_dia + 1).strftime("%Y-%m-%d")}' group by sesion, em_of_c, catalogo_id, empresa_id, oficina_id, c.codigo, c.naturaleza; "

		    ActiveRecord::Base.connection.execute(@sql)
		end
 
   		#inserta padres para detalles sin saldo	
		@sql = "insert into mayors (sesion, em_of_c, grupo, fechacbte, catalogo_id, empresa_id, oficina_id, codigo, esdebito, glosa, saldo, saldosec, created_at, updated_at)" +
				" select distinct #{@sesion}, em_of_c, 0, '#{@f_ini_menos_un_dia}', catalogo_id, empresa_id, oficina_id, codigo, esdebito, 'Saldo Inicial', 0, 0, '#{Time.now.to_date}', '#{Time.now.to_date}'" +
				" from ( select em_of_c, catalogo_id, empresa_id, oficina_id, codigo, esdebito from mayors where sesion = #{@sesion} and grupo = 1 ) m"+ 
				" where not exists (select 1 from mayors e where e.em_of_c = m.em_of_c and  e.grupo = 0 and e.sesion = #{@sesion});"
		ActiveRecord::Base.connection.execute(@sql)

		#totales por cuenta oficina empresa del grupo = 1
		@sql = "insert into mayors (sesion, em_of_c, grupo, fechacbte, catalogo_id, empresa_id, oficina_id, codigo, esdebito, glosa, debe, haber, created_at, updated_at)" +
					" select  #{@sesion} sesion, em_of_c, 2, '#{@f_ini_menos_un_dia}', catalogo_id, empresa_id, oficina_id, c.codigo, esdebito, 'TOTAL', sum(debe), sum(haber), '#{Time.now.to_date}', '#{Time.now.to_date}'"+
					" from mayors" +
					" inner join catalogos c on c.id = catalogo_id" +
					" where sesion = #{@sesion} and grupo = 1 group by em_of_c, catalogo_id, empresa_id, oficina_id, c.codigo, esdebito;"
		ActiveRecord::Base.connection.execute(@sql)

		@empresa = Empresa.first.nombre 

 		mays = Mayor.select(:em_of_c).where(sesion: @sesion).order(:codigo).distinct.pluck(:em_of_c)
 		mays.each do |may|
   			@mayor = Mayor.where(sesion: @sesion, em_of_c: may.to_i)
   			codigo_cta = Mayor.find_by(sesion: @sesion, em_of_c: may.to_i, grupo: 0).catalogo.codigo
   			nombre_cta = Mayor.find_by(sesion: @sesion, em_of_c: may.to_i, grupo: 0).catalogo.nombre
			header
			header_lead codigo_cta, nombre_cta
			table_content codigo_cta
			
			page_count.times do |i|
	        bounding_box([bounds.left, bounds.bottom], :width => bounds.width, :height => 30) {
	            move_down 5 
	            text "", :align => :center # escrive el numero de paginas y el total
	            #text "1/1", :align => :center # escrive el numero de paginas y el total
	        }
        	end	

		end
		footer	

 	end

	def header
		text @empresa, size: 15
		#stroke_color "eeeeee"
		#stroke_line [0, 680], [530, 680]
	end

	def header_lead(codigo, nombre)

		y_position = cursor - 15
		bounding_box([50, y_position], :width => 400, :heigth => 50) do
			font_size 15
			text ["Libro Mayor", nombre].join(" "), :align => :center
			move_down 2
			font_size 10
		    text codigo, :align => :center
		    move_down 2
		    font_size 8
			text "De: "+ @f_ini.strftime("%d/%m/%Y") +" Al: "+ @f_fin.strftime("%d/%m/%Y") , :align => :center, :style => :italic
		    move_down 2
		    font_size 8
			text "(Expresado en Bolivianos)", :align => :center, :style => :italic

			
		end
		move_down 10
		#draw_text @sesion, :at => [3, cursor], :size => 12	
		font_size 10	
					
	end

	def table_content(codigo)
		# #table [[1, 2],[3, 4]]
		@formato = Array.new
		table (line_item_rows codigo) do |t|
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
		 	t.column_widths = [70,40,30,220,60,60,60]
		 	t.cells.borders = []
		# 	#row(0).borders = [:bottom]
		 	t.row(0).border_width = 1
		 	t.row(0).font_style = :bold
		# 	#columns(0..6).borders = [:right]
		 	t.row(0).columns(0..8).borders = [:bottom, :top]

		 	@formato.each do |a|
		 		t.row(a.to_i).font_style = :bold
			end
		# 	#t.row(@total_fila).columns(0..7).borders = [:top]
		# 	#t.row(@total_fila).font_style = :bold

		# 	#row(4).columns(0..6).borders = [:bottom]
		# 	t.row(-1).columns(0..7).borders = [:top]
		# 	t.row(-1).columns(0..7).font_style = :bold

		 end
	end

	def line_item_rows(codigo)
		# laux1 = ""
		# laux2 = ""
		# #[["#", "Of.", "Cuenta", "Aux.1", "Aux.2", "Debe", "Haber"]] + det.codtlaux1, det.codtlaux2,
		#arr = [["FECHA", "CBTE", "OFI","LIBROS AUX", "REF", "DEBE Bs.", "HABER Bs.", "SALDO Bs.", "DEBE $.", "HABER $.", "SALDO $."]]
		arr = [["FECHA", "CBTE", "OFI", "GLOSA", "DEBE", "HABER", "SALDO"]]
		esdebito = true
		saldo = 0
		saldo_aux = 0
		saldosec = 0
		
		j = 1
		
		i = 0
		@mayor.order(:grupo, :fechacbte).map do |det|

		# 	@total_fila += 1 [det.tipocbte, det.nrocbte].join("-")
			if det.grupo == 0
				
				arr << [ {:content => det.glosa, :colspan => 4}, "", "", det.saldo.round(2)]
				saldo = det.saldo.round(2)
				saldo_aux = saldo
				#saldosec = det.saldosec.round(2)
				@formato[i] = j
				i += 1

			
			else
				if det.grupo == 1
					if det.esdebito == true
						saldo = saldo + (det.debe.round(2) - det.haber.round(2))
						#saldosec = saldosec + (det.debesec.round(2) - det.habersec.round(2))
					else
						saldo = saldo + (det.haber.round(2) - det.debe.round(2))
						#saldosec = saldosec + (det.habersec.round(2) - det.debesec.round(2))
					end

					lib_aux = ""			
					# if det.tlaux1.to_s != "0" 
					# 	lib_aux = "[" + det.tlaux1.to_s + "]" + det.libauxdet.libauxdetable_id.to_s
					# end
					if det.tlaux1.to_s != "0" 
						lib_aux = "[" + det.tlaux1.to_s + "]"+ "[" + det.libauxdet.libauxdetable_id.to_s + "]" + det.libauxdet.name.to_s
					end

					arr << [ det.fechacbte.strftime("%d-%m-%Y"), [det.tipocbte, det.nrocbte].join("-"), det.oficina.Sigla, det.glosa, det.debe.round(2), det.haber.round(2), saldo]
					j += 1
					arr << ["","","", lib_aux]
				
				else
					if det.esdebito == true
						saldo = saldo_aux + (det.debe.round(2) - det.haber.round(2))
						#saldosec = saldosec + (det.debesec.round(2) - det.habersec.round(2))
					else
						saldo = saldo_aux + (det.haber.round(2) - det.debe.round(2))
						#saldosec = saldosec + (det.habersec.round(2) - det.debesec.round(2))
					end
					arr << [ {:content => ["TOTAL: ", codigo].join(" "), :colspan => 4, :align => :right}, det.debe.round(2), det.haber.round(2), saldo]
					@formato[i] = j
					i += 1					
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
					:at => [480, 15], :style => :italic, :size => 7

	            move_down 5 
	            text "#{i+1}/#{page_count}", :align => :center # escrive el numero de paginas y el total
	            #text "1/1", :align => :center # escrive el numero de paginas y el total
	        }
        end	
	end

end