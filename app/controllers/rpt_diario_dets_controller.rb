class RptDiarioDetsController < ApplicationController
def new
  	@rpt_diario_det = RptDiarioDet.new
  	respond_to do |format|
      format.html
    end
  end

  def create
    @rpt_diario_det = RptDiarioDet.new(rpt_diario_det_params)    
      if @rpt_diario_det.valid?
      	pdf = DiarioDetPdf.new(rpt_diario_det_params[:f_ini], rpt_diario_det_params[:f_fin], session[:token])
      	send_data pdf.render, filename: ["d_", Time.now.strftime("%Y%m%d_%H%M%S"), ".pdf"].join(""),
	                          type: "application/pdf",disposition: "inline"

  	  end

  end

  private

  def rpt_diario_det_params
    params.require(:rpt_diario_det).permit(:f_ini, :f_fin)
  end
end
