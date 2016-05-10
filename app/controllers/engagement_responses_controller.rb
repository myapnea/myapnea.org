# frozen_string_literal: true

class EngagementResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner, only: [:destroy]
  before_action :set_engagement
  before_action :set_engagement_response, only: [:show, :edit, :update, :destroy]

  # POST /engagement_responses
  # POST /engagement_responses.json
  def create
    @engagement_response = @engagement.engagement_responses.where(user_id: current_user).new(engagement_response_params)

    respond_to do |format|
      if @engagement_response.save
        format.html { redirect_to root_path, notice: 'Thank you for your input!' }
        format.js {}
      else
        format.html { redirect_to root_path, notice: 'There was an error processing your response. Please try again.' }
        format.js {}
      end
    end
  end

  # DELETE /engagement_responses/1
  # DELETE /engagement_responses/1.json
  def destroy
    @engagement_response.destroy
    respond_to do |format|
      format.html { redirect_to @engagement, notice: 'Engagement response was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_engagement_response
      @engagement_response = EngagementResponse.find(params[:id])
    end

    def set_engagement
      @engagement = Engagement.find(params[:engagement_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def engagement_response_params
      params.require(:engagement_response).permit(:response)
    end
end
