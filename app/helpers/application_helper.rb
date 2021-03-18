module ApplicationHelper

  # Load Pagy front end components.
  include Pagy::Frontend

  # Controller name badge.
  def controller_badge(controller_name)
    div_classes = ["badge"]
    case controller_name
    when "Ovens"
      div_classes << "text_white" << "bg-yellow-700"
    when "Robot"
      div_classes << "text_white" << "bg-gray-700"
    when "BNA"
      div_classes << "text_white" << "bg-green-600"
    when "Dept. 5"
      div_classes << "text_white" << "bg-blue-600"
    when "Dept. 3"
      div_classes << "text_white" << "bg-purple-600"
    when "IAO"
      div_classes << "text_white" << "bg-pink-600"
    when "Waste Water"
      div_classes << "text_white" << "bg-indigo-500"
    when "epiclc.varland.com"
      div_classes << "text_white" << "bg-indigo-500"
    else
      div_classes << "text_white" << "bg-red-500"
    end
    content_tag(:div, controller_name, class: div_classes.join(" "))
  end

  # Message type badge.
  def message_type_badge(log)
    div_classes = ["badge"]
    div_classes << log.badge_classes
    content_tag(:div, log.log_type, class: div_classes.join(" "))
  end

end