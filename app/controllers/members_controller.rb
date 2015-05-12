class MembersController < ApplicationController
  before_action :set_member,                only: :show
  before_action :redirect_without_member,   only: :show

  def index
    @members = User.current.where("users.id IN (SELECT posts.user_id FROM posts WHERE posts.status IN (?) and posts.deleted = ?)", ['pending_review', 'approved'], false).where.not(forum_name: [nil, '']).order(:forum_name).page(params[:page]).per( 40 )
  end

  def show
  end

  private

    def set_member
      @member = User.current.find_by_forum_name(params[:forum_name])
    end

    def redirect_without_member
      empty_response_or_root_path(members_path) unless @member
    end

end
