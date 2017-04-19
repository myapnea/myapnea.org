# frozen_string_literal: true

# Displays public profiles for forum members.
class MembersController < ApplicationController
  before_action :find_member, only: :photo
  before_action :find_member_or_redirect, only: [:show, :badges, :posts]

  def index
    redirect_to topics_path
  end

  # GET /members/:forum_name
  def show
    @replies = @member.replies.order(created_at: :desc).page(params[:page]).per(20)
  end

  # GET /members/:forum_name/badges
  def badges
    render layout: 'application_padded'
  end

  # GET /members/:forum_name/posts
  def posts
    @replies = @member.replies.order(created_at: :desc).page(params[:page]).per(20)
    render layout: 'application_padded'
  end

  def photo
    if @member && @member.photo.size.positive?
      send_file File.join(CarrierWave::Uploader::Base.root, @member.photo.url)
    else
      head :ok
    end
  end

  private

  def find_member
    @member = User.current.where('LOWER(users.forum_name) = ?', params[:forum_name].to_s.downcase).first
  end

  def find_member_or_redirect
    find_member
    redirect_without_member
  end

  def redirect_without_member
    empty_response_or_root_path(members_path) unless @member
  end
end
