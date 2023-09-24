module ApplicationHelper

  def is_active(action)
    request.fullpath == action ? "active" : nil
  end

end
