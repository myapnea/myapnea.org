module Forem
  class ForumsController < Forem::ApplicationController

    def index
      @categories = Forem::Category.all
      redirect_to main_app.stealth_forums_path if params[:redesign] == '1'
    end
  end
end
