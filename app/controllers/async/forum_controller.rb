# frozen_string_literal: true

# Provides methods to login and register while starting a new forum topic.
class Async::ForumController < Async::BaseController
  before_action :set_chapter

  def login
    super
    if current_user
      render :create
    else
      render :new
    end
  end

  # def new_topic
  # end

  private

  def set_chapter
    @chapter = Chapter.new
  end
end
