module ApplicationHelper

  EMAIL_FORMAT = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,63}/

  def show_image(image, size= :med)
    unless image.nil?
      image.image.url(size)
    end
  end

  def active_class(link_path)
    current_page?(link_path) ? 'active' : ''
  end

  def get_genders
    User::GENDERS
  end

  def fetch_thumbnail(image, size= :small)
    unless image.nil?
      return image.image.url(size)
    end
    image_url("noimg.png")
  end

  def alert_class_for(flash_type)
  {
     success: 'alert-success',
     error: 'alert-danger',
     alert: 'alert-warning',
     notice: 'alert-info'
     }[flash_type.to_sym] || flash_type.to_s
  end

  def render_time(datetime)
    datetime.strftime("%m-%e-%y %H:%M")
  end

  def span_elem(class_name)
    content_tag(:span, '', class: "glyphicon glyphicon-#{class_name}")
  end

  def render_date(datetime)
    datetime.strftime("%m-%d-%Y")
  end

  def hide_content(content)
    'hidden' if content.blank?
  end

  def render_title
    @title || devise_titles || 'I Rated'
  end

  def devise_titles
    return 'Sign Up' if params[:controller] == 'devise/registrations' && params[:action] == 'new'
    return 'Edit Profile' if params[:controller] == 'devise/registrations' && params[:action] == 'edit'
    return 'Login' if params[:controller] == 'devise/sessions'
  end

end
