module HomeHelper

  def get_bitly_link(link_id)
    link_with_bitly = "bitly_#{link_id}"

    default_links = {
      check_risk: sleep_apnea_risk_assessment_path,
      surveys: surveys_path,
      forums: forums_path,
      facebook: "https://www.facebook.com/sharer/sharer.php?u=www.myapnea.org"
    }

    ENV[link_with_bitly].present? ? ENV[link_with_bitly] : default_links[link_id]
  end

end
