module AdminHelper

  ###
  #
  ###
=begin
  def admin_links_tag()

    if (session[:user_id] == 1)
      html_code = '<ul>'
      html_code += '<li>' +  link_to('A&ntilde;adir datos', {:controller => 'admin', :action => 'add_performers_and_authors_to_song'}) + '</li>'
      html_code += '<li>' +  link_to('A&ntilde;adir sesiones', {:controller => 'admin', :action => 'list_handling'}) + '</li>'
      html_code += '<li>' +  link_to('Bandas', {:controller => 'admin', :action => 'bands_list'})
      html_code += '</ul>'
    end

    return html_code
    
  end
=end
end
