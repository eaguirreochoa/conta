class RptMayorsController < ApplicationController
  def new
  	@rpt_mayor = RptMayor.new
    #@rpt_mayor.f_ini = Periodo.fini_ciclo(1).to_date
  	respond_to do |format|
      format.html
    end
  end

  def create
    @rpt_mayor = RptMayor.new(rpt_mayor_params)

    
      if @rpt_mayor.valid?
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
      	pdf = MayorPdf.new(rpt_mayor_params[:f_ini], rpt_mayor_params[:f_fin], session[:token])
      	send_data pdf.render, filename: ["m_", Time.now.strftime("%Y%m%d_%H%M%S"), ".pdf"].join(""),
	                          type: "application/pdf",disposition: "inline"


  	  end

  end

  private

  def rpt_mayor_params
    params.require(:rpt_mayor).permit(:f_ini, :f_fin)
  end

  def generate_pdf(token)
    Prawn::Document.new do
        formatted_text [ { :text=>"xxx.org", :styles => [:bold], :size => 30 } ]
        move_down 20
        text "Please proceed to the following web address:" 
        move_down 20
        text "http://xxx.org/finder"
        move_down 20
        text "and enter this code:"
        #move_down 20
        #formatted_text [ { :text=>token, :styles => [:bold], :size => 20 } ]
   	end.render
   end
end


  