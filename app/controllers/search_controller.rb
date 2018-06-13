# frozen_string_literal: true

# Provides back search results from across MyApnea.
class SearchController < ApplicationController
  # GET /search
  def index
    @member = User.current.find_by("LOWER(username) = ?", params[:search].to_s.downcase)
    @search = params[:search].to_s.downcase.split(/[^\w]/).reject(&:blank?).uniq.join(" & ")
    @search_documents = PgSearch.multisearch(params[:search]).page(params[:page]).per(10)
  end
end
