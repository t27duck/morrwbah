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

end
