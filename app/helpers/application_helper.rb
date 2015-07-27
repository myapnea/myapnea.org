module ApplicationHelper

  include DateAndTimeParser

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

  def simple_check(checked)
    checked ? '<span class="glyphicon glyphicon-ok"></span>'.html_safe : '<span class="glyphicon glyphicon-unchecked"></span>'.html_safe
  end

  def load_pc
    @pc = page_content(params[:action].to_s)
  end

  def page_content(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'content', "#{name}.yml"))[name]
  end

  def get_tracked_link(link_id)
    link_with_tracking = "tracking_#{link_id}"

    default_links = {
      check_risk: sleep_apnea_risk_assessment_path,
      surveys: surveys_path,
      forums: forums_path,
      facebook: "https://www.facebook.com/sharer/sharer.php?u=www.myapnea.org",
      join_from_landing: new_user_registration_path,
      join_from_sidebar: new_user_registration_path,
      join_from_forums: new_user_registration_path,
      join_from_surveys: new_user_registration_path,
      join_from_research: new_user_registration_path,
      join_from_learn: new_user_registration_path
    }

    ENV[link_with_tracking].present? ? ENV[link_with_tracking] : default_links[link_id]
  end

end
