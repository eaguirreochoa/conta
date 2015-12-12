class CiclosDatatable
  delegate :params, :fa_icon, :link_to, :ciclos_path, :edit_ciclo_path, :ciclo_path, to: :@view 

  def initialize(view) 
    @view = view 
  end 

  def as_json(options = {}) 
    { 
      data: data, 
      recordsTotal: Ciclo.count, 
      recordsFiltered: 2
    } 
  end 



private 

  def data 
    cilos = [] 
    fetch_products.map do |record| 
      product = [] 
      product << record.id 
      product << record.fini.to_date.strftime("%d/%m/%Y") 
      product << record.ffin.to_date.strftime("%d/%m/%Y") 
      product << Ciclo::TIPO[:ED]
      #if record.tipo == "ED"
      #  product << Ciclo::TIPO[:ED]
      #end

      if record.activo
        product << "Si"
      else
        product << "No"
      end
      
      product << link_to(fa_icon('info-circle lg'), ciclo_path(record), class: 'label success round') 
      product << link_to(fa_icon('edit lg'), edit_ciclo_path(record), class: 'label secondary round') 
      product << link_to(fa_icon('trash-o lg'), ciclos_path(record), method: :delete, data: { confirm: 'Are you sure?' }, class: 'label alert round') 
      cilos << product 
    end 
    cilos 
  end 

  def fetch_products 
    records = Ciclo.order("#{sort_column} #{sort_direction}") 
    records = records.page(page).per(per_page) 
    if params[:search][:value].present? 
      records = records.where("CICLOS.FINI like :search ", search: "%#{params[:search][:value]}%") 
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
    columns = %w[not_orderable CICLOS.FINI not_orderable not_orderable CICLOS.ACTIVO not_orderable not_orderable not_orderable] 
    columns[params[:order][:'0'][:column].to_i] 
  end 

  def sort_direction 
    params[:order][:'0'][:dir] == "desc" ? "desc" : "asc" 
  end 
end