class RptEstadoCuentaDetsController < ApplicationController
 def new
  	@rpt_estado_cuenta_det = RptEstadoCuentaDet.new
    #@rpt_estado_cuenta_det.f_ini = Periodo.fini_ciclo(1).to_date
    

  	respond_to do |format|
      format.html
    end
  end

  def create
    @rpt_estado_cuenta_det = RptEstadoCuentaDet.new(rpt_estado_cuenta_det_params)
    #puts "imprime params"
    #puts params[:catalogo_id]
    #puts params[:cod_lib_aux1]
    
      if @rpt_estado_cuenta_det.valid?
      	#format.html { render :show }
      	#respond_to do |format|
        	# format.pdf do
	        # 	pdf = MayorPdf.new
	        # 	send_data pdf.render, filename: "mypdf.pdf",
	        #                       type: "application/pdf",
	        #                       disposition: "inline"
	        #end
	        #format.html { render :show }
        #end

 		#@pdf = generate_pdf(session[:token])
      	#send_data(@pdf, :filename => "output.pdf", :type => "application/pdf")
      	pdf = EstadoCuentaDetPdf.new(rpt_estado_cuenta_det_params[:f_ini], rpt_estado_cuenta_det_params[:f_fin], params[:catalogo_id], params[:cod_lib_aux1], session[:token])
      	send_data pdf.render, filename: ["ec_", Time.now.strftime("%Y%m%d_%H%M%S"), ".pdf"].join(""),
	                          type: "application/pdf",disposition: "inline"


  	  end

  end

   def aux1_segun_catalogo
    #@provincias = Catalogo.select(:id,:Nombre).where("estransaccional = ? AND activo = ? AND nivel_id = ? AND grupo_id = ?", false, true, params[:nivel_id], params[:grupo_id]) 
    @b = Catalogo.find_by(id: params[:idcatalogo].to_i)

    # if @b.blank?
    #   puts "eeere"
    # else  
    #   puts "----"
    #   puts @b.codigo      
    # end

    respond_to do |format|
      format.js
    end
  end

  private

  def rpt_estado_cuenta_det_params
    params.require(:rpt_estado_cuenta_det).permit(:f_ini, :f_fin, :catalogo_id, :cod_lib_aux1)
    #rpt_estado_cuenta_det
  end
end
