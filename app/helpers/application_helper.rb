module ApplicationHelper

  def is_active(action)
    request.fullpath == action ? "active" : nil
  end

  def gravatar_for(user, options = { size: 80 })
    email = user.email.downcase
    hash = Digest::MD5.hexdigest(email)
    size = options[:size]
    gravatar_url = "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
    image_tag(gravatar_url, alt: 'Gravatar Picture', class: "rounded shadow mx-auto d-block")
  end

end
