module ApplicationHelper
  def error_messages_for(object)
    html = ''
    if object.errors.any?
      html += '<div class="error_messages">'
      html += '<h2>Form is invalid</h2>'
      html += '<ul>'
      object.errors.full_messages.each do |message|
        html += "<li>#{message}</li>"
      end
      html += '</ul>'
      html += '</div>'
    end
    html.html_safe
  end
end
