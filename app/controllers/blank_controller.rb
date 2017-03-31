# frozen_string_literal: true

# Displays pages without layouts.
class BlankController < ApplicationController
  before_action :find_question_or_redirect, only: [:question, :yoga]

  def question
    render "blank/question#{@question_id}"
  rescue
    redirect_to question_path(id: 1)
  end

  def yoga
    render "blank/yoga#{@question_id}"
  rescue
    redirect_to yoga_path(id: 1)
  end

  def landing2
    render layout: 'blank2'
  end

  private

  def find_question_or_redirect
    @question_id = params[:id].to_i
    redirect_to question_path(id: 1) unless @question_id.positive?
  end
end
