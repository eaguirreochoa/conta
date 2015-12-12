class CiclosController < ApplicationController
  before_action :set_ciclo, only: [:show, :edit, :update, :destroy]

  # GET /ciclos
  # GET /ciclos.json
  def index
    @ciclos = Ciclo.all
  end

  # GET /ciclos/1
  # GET /ciclos/1.json
  def show
  end

  # GET /ciclos/new
  def new
    @ciclo = Ciclo.new
    @ciclo.fini = @ciclo.fini_sugerida(1)
    @ciclo.empresa_id = 1
    @ciclo.activo = true
  end

  # GET /ciclos/1/edit
  def edit
  end

  # POST /ciclos
  # POST /ciclos.json
  def create
    @ciclo = Ciclo.new(ciclo_params)

    respond_to do |format|
      if @ciclo.save
        format.html { redirect_to @ciclo, notice: 'Ciclo was successfully created.' }
        format.json { render :show, status: :created, location: @ciclo }
      else
        format.html { render :new }
        format.json { render json: @ciclo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ciclos/1
  # PATCH/PUT /ciclos/1.json
  def update
    respond_to do |format|
      if @ciclo.update(ciclo_params)
        format.html { redirect_to @ciclo, notice: 'Ciclo was successfully updated.' }
        format.json { render :show, status: :ok, location: @ciclo }
      else
        format.html { render :edit }
        format.json { render json: @ciclo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ciclos/1
  # DELETE /ciclos/1.json
  def destroy
    @ciclo.destroy
    respond_to do |format|
      format.html { redirect_to ciclos_url, notice: 'Ciclo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #get '/ciclos/datatable'
  def datatable
    render json: CiclosDatatable.new(view_context) 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ciclo
      @ciclo = Ciclo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ciclo_params
      params.require(:ciclo).permit(:fini, :tipo, :activo, :empresa_id)
    end
end
