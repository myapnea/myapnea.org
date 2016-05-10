# frozen_string_literal: true

# Provides back search results from across MyApnea
class SearchController < ApplicationController
  def index
    @broadcasts = Broadcast.published.where('description ~* ?', params[:search].to_s).order(:title)
  end
end
