class DiariosDatatable 
  delegate :params, :fa_icon, :link_to, :diarios_path, :edit_diario_path, :diario_path, to: :@view 

  def initialize(view) 
    @view = view 
  end 

  def as_json(options = {}) 
    { 
      data: data, 
      recordsTotal: Diario.count, 
      recordsFiltered: 2
    } 
  end 

private 
  def data 
    diarios = [] 
    fetch_diarios.map do |record| 
      diario = [] 
      diario << record.id 
      diario << record.codigo 
      diario << record.fechacbte.to_date.strftime("%d/%m/%Y") 
      diario << record.glosagral 
      #diario << record.estado
      diario << link_to(fa_icon('info-circle lg'), diario_path(record), class: 'label success round') 
      diario << link_to(fa_icon('edit lg'), edit_diario_path(record), class: 'label secondary round') 
      #diario << link_to(fa_icon('trash-o lg'), diarios_path(record), method: :delete, data: { confirm: 'Are you sure?' }, class: 'label alert round') 
      diarios << diario 
    end 
    diarios 
  end 

  def fetch_diarios
    #records = Diario.where.not(estado: 'A' or ).order("#{sort_column} #{sort_direction}") #menos los aprobados
    records = Diario.where('esanulado =? and estado =?', false ,'F').order("#{sort_column} #{sort_direction}") #menos los aprobados
    records = records.page(page).per(per_page) 
    if params[:search][:value].present? 
      #records = records.where("DIARIOS.codigo like :search or lower(DIARIOS.fechacbte) like :search ", search: "%#{params[:search][:value]}%") 
      records = records.where("lower(DIARIOS.glosagral) like :search", search: "%#{params[:search][:value]}%") 
    end 
    records 
  end 

  def page 
    params[:start].to_i/per_page + 1 
  end 

  def per_page 
    params[:length].to_i > 0 ? params[:length].to_i : 10 
  end 

  def sort_column 
    #columns = %w[DIARIOS.id DIARIOS.codigo lower(DIARIOS.fechacbte) not_orderable] 
    columns = %w[DIARIOS.id] 
    columns[params[:order][:'0'][:column].to_i] 
  end 

  def sort_direction 
    params[:order][:'0'][:dir] == "desc" ? "desc" : "desc" 
  end 
end