class CatalogosJstree
       
  delegate :params, :fa_icon, :link_to, :catalogos_path, :edit_catalogo_path, :catalogo_path, to: :@view 

  def initialize(view) 
    @view = view 
  end 

  def as_json(options = {}) 
    data
  end 

private 

  def data 
    fold_path = ActionController::Base.helpers.asset_path("fold.png")
    file_path = ActionController::Base.helpers.asset_path("file.png")

    records = Catalogo.where("activo = 't'")
    files_set = [] 
    text =""
    records.map do |record| 
      padre =""
      if record.padre_id == "0"
        padre="#"
      else
        padre=record.padre_id.to_s
      end
      text=record.codigo.to_s + "-" + record.nombre.to_s
      
      if record.estransaccional 
        files_set << {id: record.id, parent: padre, text: text, icon: file_path, li_attr: {class: 'file'}}
        #files_set << {id: record.id, parent: padre, text: text, icon: file_path, li_attr: link_to(fa_icon('edit lg'), edit_catalogo_path(record), class: 'label secondary round') }
      else
        files_set << {id: record.id, parent: padre, text: text, icon: fold_path }
      end 
    end

    return files_set
  end 

  

end