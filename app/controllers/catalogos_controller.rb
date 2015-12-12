class CatalogosController < ApplicationController
  load_and_authorize_resource

  before_action :set_catalogo, only: [:destroy]

  # GET /catalogos
  # GET /catalogos.json
  def index
    @catalogos = Catalogo.all
  end

  #GET /catalogos/listar
  def listar
    # fold_path = ActionController::Base.helpers.asset_path("fold.png")
    # file_path = ActionController::Base.helpers.asset_path("file.png")

    
    # #records = Catalogo.where("activo = 't' and codigo like '1%'")
    # records = Catalogo.where("activo = 't'")

    # files_set = [] 
    # text =""
    # records.map do |record| 
    #   padre =""
    #   if record.padre == 0
    #     padre="#"
    #   else
    #     padre=record.padre.to_s
    #   end

    #   text=record.codigo.to_s + "-" + record.nombre.to_s
    #   if record.estransaccional 
    #     files_set << {id: record.id, parent: padre, text: text, icon: file_path, li_attr: {class: 'file'} }
    #   else
    #     files_set << {id: record.id, parent: padre, text: text, icon: fold_path }
    #   end 
    # end

    # respond_to do |format|
    #   format.json { render json: files_set }
    # end

    render json: CatalogosJstree.new(view_context)

  end

  # GET /catalogos/1
  # GET /catalogos/1.json
  def show

  end

  def imprimir
    pdf = PlanCuentaPdf.new()
        send_data pdf.render, filename: "mypdf.pdf",
                            type: "application/pdf",disposition: "inline"
  end

  # GET /catalogos/new
  def new
    puts "agregar id catalogo"
    puts params[:id]
    @c = Catalogo.where("id = ? AND activo = ? ", params[:id].to_i, true).first

    @catalogo = Catalogo.new    
    @catalogo.padre_id = params[:id].to_i
    @catalogo.grupo_id = @c.grupo_id
    @b = Catalogo.find_by(id: params[:id].to_i)
    @catalogo.padre = @c.codigo
    @catalogo.sigla =  @b.cuenta.secuenciasugerida

    @papa = Catalogo.select(:id, :codigo, :nombre).where(" activo = ? ", true)
    load_Obj

    # @grupos = Grupo.all
    # @nivels = Nivel.select(:id, :nombre)#.where("nombre != ?", "CAPITULO" )
    # @papa = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ? ", false, true)
    # @ajuste = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ?", true, true )
    # @laux = Libroauxiliar.select(:id, :descripcion).where("activo = ?", true)
   
   end

  # GET /catalogos/1/edit
  def edit
    @catalogo = Catalogo.find(params[:id])
  
    @papa = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ? AND nivel_id = ? AND grupo_id = ? ", false, true, @catalogo.nivel_id , @catalogo.grupo_id )
    load_Obj

    respond_to do |format|
      format.js
      format.html { render :edit }
    end
   
  end

  # POST /catalogos
  # POST /catalogos.json
  def create
    # catalogo_params[:usalaux1] = '0'
    # catalogo_params[:usalaux2] = '0'
    # catalogo_params[:estransaccional] = '0'

    @catalogo = Catalogo.new(catalogo_params)

    respond_to do |format|
      if @catalogo.save
        format.html { redirect_to @catalogo, notice: 'Catalogo was successfully created.' }
        format.json { render :show, status: :created, location: @catalogo }
      else
        load_Obj
        @papa = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ? AND nivel_id = ? AND grupo_id = ? ", false, true, catalogo_params[:nivel_id], catalogo_params[:grupo_id] )
        format.html { render :new }
        format.json { render json: @catalogo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalogos/1
  # PATCH/PUT /catalogos/1.json
  def update
    respond_to do |format|
      if @catalogo.update(catalogo_params)
        format.html { redirect_to @catalogo, notice: 'Catalogo was successfully updated.' }
        format.json { render :show, status: :ok, location: @catalogo }
      else
        format.html { render :edit }
        format.json { render json: @catalogo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogos/1
  # DELETE /catalogos/1.json
  def load_Obj
    @grupos = Grupo.all
    @nivels = Nivel.select(:id, :nombre).where("nombre != ?", "CAPITULO" )
#    @papa = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ? ", false, true)    
    @ajuste = Catalogo.select(:id, :codigo, :nombre).where("estransaccional = ? AND activo = ?", true, true )
    @laux = Libroauxiliar.select(:id, :descripcion).where("activo = ?", true)
  end

  def update_padre
    #@provincias = Catalogo.select(:id,:Nombre).where("estransaccional = ? AND activo = ? AND nivel_id = ? AND grupo_id = ?", false, true, params[:nivel_id], params[:grupo_id])
    @papa = Catalogo.select(:id, :codigo, :nombre).where("activo = ? AND nivel_id = ? AND grupo_id = ?", true, params[:idnivel].to_i - 1, params[:idgrupo])
    @b = @papa.first

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

  def update_cuentasugerida
    @b = Catalogo.find_by(id: params[:idpadre].to_i)
    #puts @b.cuenta.secuenciasugerida
    
    respond_to do |format|
      format.js
    end
  end

  def select_nodo
    @b = Catalogo.find_by(id: params[:idnodo].to_i)
    #puts @b.cuenta.secuenciasugerida
    
    respond_to do |format|
      format.js
    end
  end    
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalogo
      @catalogo = Catalogo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalogo_params
      #params.require[:catalogo].permit(:grupo_id, :nivel_id, :codigo, :padre, :sigla, :nombre, :usalaux1, :tlaux1, :usalaux2, :tlaux2, :idctaajusteufv, :idctaajustetc, :esflujodeejec, :estransaccional, :activo )
      params.require(:catalogo).permit(:codigo, :nombre, :sigla, :padre, :padre_id, :estransaccional, :esflujodeejec, :usalaux1, :usalaux2, :tlaux1, :tlaux2, :idctaajustetc, :idctaajusteufv, :idctaacumajusteufv, :activo, :nivel_id, :grupo_id, :naturaleza)
      
    end   
end