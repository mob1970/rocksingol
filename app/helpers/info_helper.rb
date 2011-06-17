module InfoHelper

	###
	#
	###
	def post_link_to(url, text)
		
		url_without_params, params_string = CGI::unescape(url).split('?')	
		if (params_string)
			params = Hash.new()
			params_string.split('&amp;').each do |param|
				name, value = param.split('=')
				params[name] = value
			end
		end

		html_code = "<a href='#{url_without_params}' onclick=\"var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;"
		html_code += 'var s;'
		
		#Adding authenticity_token
		html_code += 's = document.createElement(\'input\');'
		html_code += 's.setAttribute(\'type\', \'hidden\');'
		html_code += "s.setAttribute(\'name\', \'authenticity_token\');" 
		html_code += "s.setAttribute(\'value\', \'#{form_authenticity_token}\');" 
		html_code += 'f.appendChild(s);'
		
		
		params.keys.each do |key|
			html_code += 's = document.createElement(\'input\');'
			html_code += 's.setAttribute(\'type\', \'hidden\');'
			html_code += "s.setAttribute(\'name\', \'#{key}\');" 
			html_code += "s.setAttribute(\'value\', \'#{params[key]}\');" 
			html_code += 'f.appendChild(s);'
		end
		html_code += "f.submit();return false;\">#{text || url_without_params}</a>" 
		
		return html_code

	end

end
