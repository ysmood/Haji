#compdef haji

<%
	list = ''
	@@methods_info.each { |e|
		list += "#{e[0].sub(/\n/, '').sub(/[\s\(].+/, '')} "
	}
%>

_arguments "1: :(<%= list %>)"
