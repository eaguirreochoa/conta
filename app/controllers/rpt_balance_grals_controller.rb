class RptBalanceGralsController < ApplicationController
 def new
  	@rpt_balance_gral = RptBalanceGral.new
    #@rpt_balance_gral.f_ini = '20150101'.to_date

  	respond_to do |format|
      format.html
    end
  end

  def create
    @rpt_balance_gral = RptBalanceGral.new(rpt_balance_gral_params)

    
      if @rpt_balance_gral.valid?
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

      	pdf = BalanceGralPdf.new(rpt_balance_gral_params[:f_ini], rpt_balance_gral_params[:f_fin], rpt_balance_gral_params[:catalogo_ids], session[:token])
      	send_data pdf.render, filename: ["bg_", Time.now.strftime("%Y%m%d_%H%M%S"), ".pdf"].join(""),
	                          type: "application/pdf",disposition: "inline"


  	  end

  end

  private

  def rpt_balance_gral_params
    params.require(:rpt_balance_gral).permit(:f_ini, :f_fin, :catalogo_ids => [])
    #rpt_balance_gral
  end
end
