# frozen_string_literal: true

# Chapters are a redesign of forum topics with improved replies and discussion.
class ChaptersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_viewable_chapter_or_redirect, only: [:show]
  before_action :find_editable_chapter_or_redirect, only: [:edit, :update, :destroy]

  # GET /chapters
  def index
    @order = scrub_order(Chapter, params[:order], 'pinned desc, last_reply_at desc, id desc')
    if ['reply_count', 'reply_count desc'].include?(params[:order])
      @order = params[:order]
    end
    @chapters = Chapter.current.reply_count.order(@order).page(params[:page]).per(40)
  end

  # GET /chapters/1
  def show
    @page = (params[:page].to_i > 1 ? params[:page].to_i : 1)
    @replies = @chapter.replies.includes(:chapter).where(reply_id: nil).page(@page).per(Chapter::REPLIES_PER_PAGE)
    @chapter.increment! :view_count
    current_user.read_chapter!(@chapter, @replies.last.id) if current_user
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
    if current_user.moderator?
      params.require(:chapter).permit(:title, :slug, :description, :pinned)
    else
      params.require(:chapter).permit(:title, :slug, :description)
    end
  end
end
