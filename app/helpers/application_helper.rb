module ApplicationHelper
  
  def unread_count(title, count)
    "#{title} (<span class='unread-count'>#{count}</span>)".html_safe
  end

  def error_messages_for(object)
    html = ""
    if object.errors.any?
      html += "<div class='error_messages'>"
      html += "<h3>Form is invalid</h3>"
      html += "<ul>"
      object.errors.full_messages.each do |message|
        html += "<li>#{message}</li>"
      end
      html += "</ul>"
      html += "</div>"
    end
    html.html_safe
  end

  def mobile_browser?
    # Season this regexp to taste. I prefer to treat iPad as non-mobile.
   if (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
     true
   else
     false
   end
  end
end
