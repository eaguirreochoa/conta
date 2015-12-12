class RptBalGralSumaSaldosController < ApplicationController
 def new
  	@rpt_bal_gral_suma_saldo = RptBalGralSumaSaldo.new
    #@rpt_bal_gral_suma_saldo.f_ini = '20150101'.to_date

  	respond_to do |format|
      format.html
    end
  end

  def create
    @rpt_bal_gral_suma_saldo = RptBalGralSumaSaldo.new(rpt_bal_gral_suma_saldo_params)

    
      if @rpt_bal_gral_suma_saldo.valid?
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

      	pdf = BalGralSumaSaldoPdf.new(rpt_bal_gral_suma_saldo_params[:f_ini], rpt_bal_gral_suma_saldo_params[:f_fin], rpt_bal_gral_suma_saldo_params[:catalogo_ids], session[:token])
      	send_data pdf.render, filename: ["bss_", Time.now.strftime("%Y%m%d_%H%M%S"), ".pdf"].join(""),
	                          type: "application/pdf",disposition: "inline"


  	  end

  end

  private

  def rpt_bal_gral_suma_saldo_params
    params.require(:rpt_bal_gral_suma_saldo).permit(:f_ini, :f_fin, :catalogo_ids => [])
    #rpt_bal_gral_suma_saldo
  end
end