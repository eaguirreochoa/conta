class DiariosController < ApplicationController
  load_and_authorize_resource
  before_action :set_diario, only: [:show, :edit, :update, :destroy]

  # GET /diarios
  # GET /diarios.json
  def index
    #@diarios = Diario.where.not(estado: 'A')
  end

  # GET /diarios/1
  # GET /diarios/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = DiarioPdf.new(@diario, view_context)
        send_data pdf.render, filename: "mypdf.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  # GET /diarios/new
  def new
    @diario = Diario.new
    #@periodo = Periodo.select(:nro).where("? BETWEEN fini and ffin", Time.now.to_date)
    #@periodo = Periodo.id_periodo(Time.now.to_date, 1)
    #@nro_comprobante = Diario.nro_cbte(1, 1, @periodo)
    #Correlcbte.nro_cbte(self.empresa_id, self.tipocomprobante_id, self.fechacbte.to_date)

    @diario.empresa_id = 1
    @diario.tipocomprobante_id = 1
    @diario.origenasiento_id = 1
    @diario.esanulado = false
    @diario.fechacbte = Periodo.fecha_ini_periodo(1)
    @diario.estado = 'F'
    @diario.tc = Conta::TCV_CONST
    @diario.nrocbte = Correlcbte.nro_cbte(1, 1, @diario.fechacbte)
    @diario.build_correlcbte(nro: @nro_comprobante)

    #session[:nro_cbte] = @nro_comprobante

    load_Obj
  end

  # GET /diarios/1/edit
  def edit
    load_Obj
    ##se actualiza el objeto laux
    

    respond_to do |format|
      format.html
    end
  end

  # POST /diarios
  # POST /diarios.json
  def create
    @diario = Diario.new(diario_params)
    #session[:glosagral] = @diario.glosagral    

    respond_to do |format|
      if @diario.save
        format.html { redirect_to @diario, notice: 'Diario was successfully created.' }
        format.json { render :show, status: :created, location: @diario }
        
      else
        load_Obj

        # @diario = Diario.new
        # @diario.build_correlcbte(nro: session[:nro])
        #@diario.glosagral = session[:glosagral]       

        format.html { render :new }
        format.json { render json: @diario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diarios/1
  # PATCH/PUT /diarios/1.json
  def update

    respond_to do |format|
      if @diario.update_attributes(diario_params)
        format.html { redirect_to @diario, notice: 'Diario was successfully updated.' }
        format.json { render :show, status: :ok, location: @diario }
      else
        load_Obj
        format.html { render :edit }
        format.json { render json: @diario.errors, status: :unprocessable_entity }
      end
    end
  end

  def anular
    @diario.esanulado = true
    @diario.save
    puts "se anulo"
    puts @diario.id
    respond_to do |format|
      format.html { redirect_to diarios_url, notice: 'El comprobante fue anulado correctamente.' }
      format.json { head :no_content }
    end  
  end
  # DELETE /diarios/1
  # DELETE /diarios/1.json
  def destroy
    #@diario.destroy
    @diario.esaunlado  = true
    @diario.save
    respond_to do |format|
      format.html { redirect_to diarios_url, notice: 'Diario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  #GET /diarios/listar
  def listar 
    render json: DiariosDatatable.new(view_context) 
  end 

  #actualiza combo moneda, laux1 y laux2 depeniendo del tipo de cuenta
  #GET /diarios/update_segun_catalogo
  def update_segun_catalogo
    @b = Catalogo.find_by(id: params[:idcuenta].to_i)
    #puts @b.cuenta.secuenciasugerida
    
    respond_to do |format|
      format.js
    end
  end

  def buscar_cuenta
    a = params[:codigo].to_s

    @b = Catalogo.select(:id, :nombre).where("codigo LIKE ? and estransaccional = ? AND activo = ?", "#{a}%", true, true)
    
    #puts @b.cuenta.secuenciasugerida
    
    respond_to do |format|
      format.js
    end
  end

 
  def update_nrocbte     
    #@periodo = Periodo.id_periodo(params[:fecha].to_date, params[:idempresa].to_i)
    #puts @periodo  
    #@nro_comprobante = Diario.nro_cbte(params[:idempresa].to_i, params[:idtipocbte].to_i, @periodo)
    @nro_comprobante = Correlcbte.nro_cbte(params[:idempresa].to_i, params[:idtipocbte].to_i, params[:fecha].to_date )
    #session[:nro] = @nro_comprobante
    #@nro_comprobante = Diario.nro_cbte(1, 1, @periodo)
    
    
    respond_to do |format|
      format.js
    end
  end

  private
    def load_Obj
      @empresas = Empresa.all
      @tipocomprobantes =  Tipocomprobante.all
      @oficinas = Oficina.all
      @fondos = Fondo.all
      @monedas = Moneda.where("esufv = ?",false)
      @lauxs = Libroauxiliar.select(:id, :descripcion).where("activo = ?", true)
      @catalogos = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ? ", true, true).order(:codigo)  
      @libauxdets = Libauxdet.select(:id, :name)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_diario
      @diario = Diario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diario_params
      params.require(:diario).permit(:nrocbte, :fechacbte, :glosagral, :esanulado, :estado, :tipocomprobante_id, :origenasiento_id, :empresa_id, :tc, diariodets_attributes: [:id, :tlaux1, :tlaux2, :codtlaux1, :libauxdet_id, :codtlaux2, :glosa, :debeori, :haberori, :monto, :tcori, :item, :esdebito, :catalogo_id, :oficina_id, :fondo_id, :moneda_id, :_destroy], correlcbte_attributes: [:id, :nro, :tipocomprobante_id, :empresa_id, :_destroy])

    end
end
