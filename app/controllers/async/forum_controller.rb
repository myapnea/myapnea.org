# frozen_string_literal: true

# Provides methods to login and register while creating a blog post comment.
class Async::ForumController < Async::BaseController
  before_action :set_chapter, only: [:login, :new_topic]

  def login
    super
    if current_user
      render :create
    else
      render :new
    end
  end

  def register
    super
    render text: 'register'
  end

  def new_topic
  end

  private

  def set_chapter
    @chapter = Chapter.new
  end
end
