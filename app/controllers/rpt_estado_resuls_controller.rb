class RptEstadoResulsController < ApplicationController
def new
  	@rpt_estado_resul = RptEstadoResul.new
    #@rpt_estado_resul.f_ini = '20150101'.to_date

  	respond_to do |format|
      format.html
    end
  end

  def create
    @rpt_estado_resul = RptEstadoResul.new(rpt_estado_resul_params)

    
      if @rpt_estado_resul.valid?
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

      	pdf = EstadoResulPdf.new(rpt_estado_resul_params[:f_ini], rpt_estado_resul_params[:f_fin], rpt_estado_resul_params[:catalogo_ids], session[:token])
      	send_data pdf.render, filename: ["er_", Time.now.strftime("%Y%m%d_%H%M%S"), ".pdf"].join(""),
	                          type: "application/pdf",disposition: "inline"


  	  end

  end

  private

  def rpt_estado_resul_params
    params.require(:rpt_estado_resul).permit(:f_ini, :f_fin, :catalogo_ids => [])
    #rpt_balance_gral
  end
end
