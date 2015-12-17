module Admin::ResearchArticlesHelper

  def research_article_photo_url(research_article)
    if research_article.photo.present?
      photo_admin_research_article_path(research_article)
    else
      'default-user.jpg'
    end
  end

end
