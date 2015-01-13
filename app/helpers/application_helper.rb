module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end


  def markdown(text)
    text = '' if text.nil?
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    markdown.render(text).html_safe
  end

  def beta_enabled?(current_user, params)
    if params[:beta] == '1'
      true
    elsif params[:beta] == '0'
      false
    elsif current_user and current_user.beta_opt_in?
      true
    else
      false
    end
  end

end
