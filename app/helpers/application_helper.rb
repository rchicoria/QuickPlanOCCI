module ApplicationHelper

  # Definir título da página (<title> do html)
  def page_title(page_title)
    content_for(:page_title) { page_title }
  end

  # Definir título da aplicação (que aparece à frente do logotipo)
  def app_title(app_title)
    content_for(:app_title) { app_title }
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :id => "hidden_button")
  end
end
