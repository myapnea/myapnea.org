# frozen_string_literal: true

# Provides back search results from across MyApnea
class SearchController < ApplicationController
  def index
    @search = params[:search].to_s.downcase.split(/[^\w]/).reject(&:blank?).uniq.join(' & ')
    @broadcasts = Broadcast.full_text_search(@search)
  end
end
