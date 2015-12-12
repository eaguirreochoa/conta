class DiarioPdf < Prawn::Document
	
	def initialize(diario, view)
		super()
		@total_fila = 0
		@diario = diario
		@view = view
		header
		header_lead
		table_content
		footer
	end

	def header
		text @diario.empresa.nombre, size: 15
	end

	def header_lead
		y_position = cursor - 15
		bounding_box([150, y_position], :width => 270, :heigth => 50 ) do
			font_size 15
			text "COMPROBANTE DE " + @diario.tipocomprobante.nombre.upcase +  " # #{@diario.correlcbte.nro}"
			move_down 8
			#font_size 10
			draw_text "Fecha: "+ @diario.fechacbte.strftime("%d/%m/%Y") +" Tc: "+ @diario.tc.to_s , :style => :italic, :at => [60, cursor], :size => 10
		end
		move_down 20
		font_size 12	

		text "Glosa: " + @diario.glosagral
		move_down 10
		font_size 10	
					
	end

	def table_content
		#table [[1, 2],[3, 4]]
		table (line_item_rows) do |t|
			# #cells.padding = 8
			# cells.borders = [:bottom]
			# cells.border_width = 0.5

			# row(0).border_width = 1.5
			# row(-2).border_width = 1.5
			# #row(-1).background_color = "f0ad4e"
			# row(-1).borders = []


			# self.header = true
			#self.row_colors = ['dddddd', 'ffffff']
			t.column_widths = [15,100,250,70,70]
			t.cells.borders = []
			#row(0).borders = [:bottom]
			t.row(0).border_width = 1
			t.row(0).font_style = :bold
			#columns(0..6).borders = [:right]
			t.row(0).columns(0..5).borders = [:bottom, :top]

			#t.row(total_fila).columns(0..7).borders = [:top]
			#t.row(total_fila).font_style = :bold

			#row(4).columns(0..6).borders = [:bottom]
			t.row(-1).columns(0..7).borders = [:top]
			t.row(-1).columns(0..7).font_style = :bold

		end
	end

	def line_item_rows
		laux1 = ""
		laux2 = ""
		#[["#", "Of.", "Cuenta", "Aux.1", "Aux.2", "Debe", "Haber"]] + det.codtlaux1, det.codtlaux2,
		arr = [["#", "CUENTA-OFI", "DESCRIPCION","DEBE", "HABER" ]]


		#total_fila = 0
		@diario.diariodets.map do |det|

			#total_fila += 1
			if det.libauxdet_id == 0
				laux1 = ""
			else
				#laux1 = "[" + det.tlaux1.to_s + "]" + det.libauxdet.name.to_s
				laux1 = "[" + det.tlaux1.to_s + "]"+ "[" + det.libauxdet.libauxdetable_id.to_s + "]" + det.libauxdet.name.to_s
				
				#total_fila += 1
			end		
 
			#arr << [det.item, [det.catalogo.codigo, det.oficina.Sigla].join("-"), det.codtlaux2 ,det.debe, det.haber]
			#arr << ["" , "" , {:content => det.catalogo.nombre, :colspan => 2}, "" , "" , ""]
		
			arr << [det.item, [det.catalogo.codigo, det.oficina.Sigla].join("-"), det.catalogo.nombre ,det.debe.round(2), det.haber.round(2)]
			arr << ["", "" , {:content => laux1, :size => 9, :padding => [5,5,5,10] }, ""]
			

		end
		#total_fila += 1
		 
		
		arr << ["", "", "TOTAL:", @diario.diariodets.sum(:debe).round(2), @diario.diariodets.sum(:haber).round(2)]

		liteal = []

		liteal = @diario.diariodets.sum(:debe).round(2).to_s.split(".")

		@liteal_word = ""

		#@liteal_word = (liteal[0].to_i).to_words + "#{liteal[1]}/100 Bolivianos"
		@liteal_word = ((liteal[0].to_i).to_words).capitalize + " #{liteal[1]}/100 Bolivianos"


		return arr

	end

	def footer
move_down(10)
		text "Total Literal: #{@liteal_word}", :align => :left
    	#table [["","","",""]], :header => false, :column_heights => 30, :column_widths => {0 => 130, 1 => 130, 2 => 130, 3 => 130}, :row_colors => ["F0F0F0", "FFFFCC"]
    	if @diario.tipocomprobante_id == 2
    		table [["Elaborado.","Revisado.","Autorizado.","Recibi Conforme."]], :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 8, :width => 130, :height => 40 }
    	else
    		table [["Elaborado.","Revisado.","Autorizado."]], :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 8, :width => 170, :height => 40 }
    	end

        move_down(10)
        


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
	            #text "#{i+1}/#{page_count}", :align => :center # escrive el numero de paginas y el total
	            text "1/1", :align => :center # escrive el numero de paginas y el total
	        }
        end		
	end

	def price(num)
		@view.number_to_currency(num)		
	end
end