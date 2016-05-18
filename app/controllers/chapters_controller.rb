# frozen_string_literal: true

# Chapters are a redesign of forum topics with improved replies and discussion.
class ChaptersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_viewable_chapter_or_redirect, only: [:show]
  before_action :find_editable_chapter_or_redirect, only: [:edit, :update, :destroy]

  # GET /chapters
  def index
    @chapters = Chapter.current
                       .order(pinned: :desc, last_reply_at: :desc, id: :desc)
                       .page(params[:page]).per(40)
  end

  # GET /chapters/1
  def show
    @chapter.increment! :view_count
  end

  # GET /chapters/new
  def new
    @chapter = current_user.chapters.new
  end

  # GET /chapters/1/edit
  def edit
  end

  # POST /chapters
  def create
    @chapter = current_user.chapters.new(chapter_params)

    if @chapter.save
      @chapter.touch(:last_reply_at)
      redirect_to @chapter, notice: 'Topic was successfully created.'
    else
      render :new
    end
  end

  # PATCH /chapters/1
  def update
    if @chapter.update(chapter_params)
      redirect_to @chapter, notice: 'Topic was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /chapters/1
  def destroy
    @chapter.destroy
    redirect_to chapters_path, notice: 'Topic was successfully deleted.'
  end

  private

  def viewable_chapters
    Chapter.current
  end

  def find_viewable_chapter_or_redirect
    @chapter = viewable_chapters.find_by_slug params[:id]
    redirect_without_chapter
  end

  def find_editable_chapter_or_redirect
    @chapter = current_user.editable_chapters.find_by_slug params[:id]
    redirect_without_chapter
  end

  def redirect_without_chapter
    empty_response_or_root_path(chapters_path) unless @chapter
  end

  def chapter_params
    params.require(:chapter).permit(:title, :slug, :description)
  end
end
