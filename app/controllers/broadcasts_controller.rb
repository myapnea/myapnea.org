# frozen_string_literal: true

# Allows community contributors to view and modify blog posts.
class BroadcastsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_community_contributor
  before_action :find_broadcast_or_redirect, only: [:show, :edit, :update, :destroy]

  # GET /broadcasts
  def index
    @broadcasts = Broadcast.current.order(publish_date: :desc, id: :desc)
                           .page(params[:page]).per(40)
  end

  # GET /broadcasts/1
  def show
  end

  # GET /broadcasts/new
  def new
    @broadcast = current_user.broadcasts.new(publish_date: Time.zone.today)
  end

  # GET /broadcasts/1/edit
  def edit
  end

  # POST /broadcasts
  def create
    @broadcast = current_user.broadcasts.new(broadcast_params)

    if @broadcast.save
      redirect_to @broadcast, notice: 'Broadcast was successfully created.'
    else
      render :new
    end
  end

  # PATCH /broadcasts/1
  def update
    if @broadcast.update(broadcast_params)
      redirect_to @broadcast, notice: 'Broadcast was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /broadcasts/1
  def destroy
    @broadcast.destroy
    redirect_to broadcasts_path, notice: 'Broadcast was successfully destroyed.'
  end

  private

  def find_broadcast_or_redirect
    @broadcast = current_user.editable_broadcasts.find_by_slug params[:id]
    redirect_without_broadcast
  end

  def redirect_without_broadcast
    empty_response_or_root_path(broadcasts_path) unless @broadcast
  end

  def broadcast_params
    params[:broadcast] ||= { blank: '1' }
    parse_date_if_key_present(:broadcast, :publish_date)
    params.require(:broadcast).permit(
      :title, :slug, :short_description, :description, :pinned, :archived,
      :publish_date, :published, :keywords, :category_id
    )
  end

  def check_community_contributor
    return if current_user.community_contributor?
    redirect_to root_path, alert: 'Only community editors may manage blog posts.'
  end

  def parse_date_if_key_present(object, key)
    return unless params[object].key?(key)
    params[object][key] = parse_date(params[object][key]) if params[object].key?(key)
  end
end
