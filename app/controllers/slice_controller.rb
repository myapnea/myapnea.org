# frozen_string_literal: true

# Allows users to access Slice surveys.
class SliceController < ApplicationController
  # before_action :authenticate_user!

  layout "layouts/full_page_sidebar"

  # GET /surveys
  def surveys
    redirect_to slice_research_path unless current_user
  end

  # # GET /research
  # def research
  # end
end
