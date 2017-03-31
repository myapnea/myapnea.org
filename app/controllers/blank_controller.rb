# frozen_string_literal: true

# Displays pages without layouts.
class BlankController < ApplicationController
  before_action :find_question_or_redirect, only: [:question, :yoga]

  def question
    render "blank/question#{@question_id}"
  rescue
    redirect_to question_path(id: 1)
  end

  def menu
    render layout: 'blank2'
  end

  def yoga
    render "blank/yoga#{@question_id}", layout: 'blank2'
  rescue
    redirect_to yoga_path(id: 1)
  end

  def sky
    render layout: 'blank2'
  end

  def sunset
    render layout: 'blank2'
  end

  def night
    render layout: 'blank2'
  end

  def blue
    render layout: 'blank2'
  end

  def orange
    render layout: 'blank2'
  end

  def green
    render layout: 'blank2'
  end

  private

  def find_question_or_redirect
    @question_id = params[:id].to_i
    redirect_to question_path(id: 1) unless @question_id.positive?
  end
end
