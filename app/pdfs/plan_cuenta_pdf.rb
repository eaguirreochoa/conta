class PlanCuentaPdf < Prawn::Document
	
	def initialize()
		super()
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
		@catalogo = Catalogo.where("activo = ?", true).order(:codigo)
	end

	def header
		text @empresa, size: 15
		#stroke_color "eeeeee"
		#stroke_line [0, 680], [530, 680]
	end

	def header_lead
		y_position = cursor - 15
		bounding_box([200, y_position], :width => 270, :heigth => 50 ) do
			font_size 15
			text "Plan de Cuentas"
			#move_down 3
			#font_size 10
		end
		move_down 15
		font_size 10	
					
	end

	def table_content

		table (line_item_rows) do |t|
			t.column_widths = [100,300,100]
			t.cells.borders = []
			t.row(0).border_width = 1
			t.row(0).font_style = :bold

			t.row(0).columns(0..3).borders = [:bottom]

			#t.row(-1).columns(0..3).borders = [:top]
			#t.row(-1).columns(0..3).font_style = :bold

		end
	end

	def line_item_rows
		arr = [["CODIGO", "NOMBRE", "NATURALEZA"]]
		
		@catalogo.map do |det|
			arr << [det.codigo, det.nombre, det.naturaleza]
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
	        }
        end		
	end

	def price(num)
		@view.number_to_currency(num)		
	end
end