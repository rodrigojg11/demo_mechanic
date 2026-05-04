module ApplicationHelper
  def icon(name, size: 18)
    render partial: "shared/icon", locals: { name: name, size: size }
  end
end
