# frozen_string_literal: true

# Provides back search results from across MyApnea.
class SearchController < ApplicationController
  layout "layouts/full_page"

  # GET /search
  def index
    clean_search = params[:search].to_s.squish.downcase
    @member = User.current.find_by("LOWER(username) = ?", params[:search].to_s.downcase)
    @search = clean_search.split(/[^\w]/).reject(&:blank?).uniq.join(" & ")
    @search_documents = PgSearch.multisearch(params[:search]).page(params[:page]).per(10)
    if clean_search.present?
      search = Search.where(search: clean_search).first_or_create
      search.update results_count: @search_documents.total_count
      search.increment! :search_count
    end
  end
end
