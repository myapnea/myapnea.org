# frozen_string_literal: true

# Displays pages without layouts.
class BlankController < ApplicationController
  before_action :find_question_or_redirect, only: [:question, :yoga]

  layout 'full_page'

  def question
    render "blank/question#{@question_id}"
  rescue
    redirect_to research_path
  end

  def yoga
    render "blank/yoga#{@question_id}"
  rescue
    redirect_to research_path
  end

  def landing2
    render layout: 'full_page_no_header'
  end

  def landing3
    render layout: 'full_page'
  end

  def landing5
    render layout: 'full_page_no_header'
  end

  def landing4
    @menu = true
    if @menu
      render layout: 'full_page'
    else
      render layout: 'full_page_no_header'
    end
  end

  private

  def find_question_or_redirect
    @question_id = params[:id].to_i
    redirect_to question_path(id: 1) unless @question_id.positive?
  end
end
