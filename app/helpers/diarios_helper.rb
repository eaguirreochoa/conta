module DiariosHelper
  #https://www.fococoder.com/articles/37
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |questions_for_form|
    	puts ""
        render(association.to_s.singularize + "_fields", f: questions_for_form)
    end
    link_to(name, '', class: "add_fields", data: { id: id, fields: fields.gsub("\n", "")})
  end

end
