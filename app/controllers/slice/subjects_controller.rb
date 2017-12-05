# frozen_string_literal: true

# Allows users to consent and get added to active studies.
class Slice::SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, only: [
    :show, :edit, :update, :destroy,
    :start, :page, :resume, :submit_page, :complete
  ]
  before_action :find_page, only: [:page, :submit_page]

  layout "layouts/full_page"

  # GET /slice/subjects
  def index
    @subjects = current_user.subjects
  end

  # # GET /slice/subjects/1
  # def show
  # end

  # GET /slice/subjects/new
  def new
    @subject = current_user.subjects.new
  end

  # # GET /slice/subjects/1/edit
  # def edit
  # end

  # POST /slice/subjects
  def create
    @subject = current_user.subjects.new(subject_params)
    if @subject.save
      @subject.update(consented_at: Time.zone.now)
      @subject.find_or_create_remote_subject!
      redirect_to slice_surveys_path, notice: "Subject was successfully created."
    else
      render :new
    end
  end

  # PATCH /slice/subjects/1
  def update
    if @subject.update(subject_params)
      redirect_to slice_surveys_path, notice: "Subject was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /slice/subjects/1
  def destroy
    @subject.destroy
    redirect_to slice_surveys_path, notice: "Subject was successfully deleted."
  end



  # GET /slice/subjects/1  ....  /survey/:event/:design/start
  def start
    survey_in_progress
    redirect_to page_slice_subject_path(@subject, params[:event], params[:design], 1)
  end

  # GET /slice/subjects/1  ....  /survey/:event/:design/:page
  def page
    @json = @subject.page_event_survey(params[:event], params[:design], @page)
    @survey = Slice::Survey.new(json: @json)
    if @json.present?
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
    end
    if @json.blank?
      redirect_to complete_slice_subject_path(@subject, params[:event], params[:design])
    else
      render "slice/survey/page"
    end
  end

  # GET /slice/subjects/1  ....  /survey/:event/:design/:resume
  def resume
    survey_in_progress
    @json = @subject.resume_event_survey(params[:event], params[:design])
    @survey = Slice::Survey.new(json: @json)
    if @json.blank?
      redirect_to complete_slice_subject_path(@subject, params[:event], params[:design])
    else
      @page = @json.dig("design", "current_page")
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
      render "slice/survey/page"
    end
  end

  # PATCH /slice/survey/:event/:design/:page
  def submit_page
    if params[:response].is_a?(ActionController::Parameters)
      value = {
        day: params[:response][:day],
        month: params[:response][:month],
        year: params[:response][:year],
        hours: params[:response][:hours],
        minutes: params[:response][:minutes],
        seconds: params[:response][:seconds],
        period: params[:response][:period],
        pounds: params[:response][:pounds],
        ounces: params[:response][:ounces],
        feet: params[:response][:feet],
        inches: params[:response][:inches]
      }
    else
      value = params[:response]
    end
    (@json, @status) = @subject.submit_response_event_survey(params[:event], params[:design], @page, value, request.remote_ip)
    if @status.is_a?(Net::HTTPOK)
      redirect_to page_slice_subject_path(@subject, params[:event], params[:design], @page + 1)
    elsif @json
      @section = Slice::Section.new(json: @json.dig("section")) if @json.dig("section").present?
      @variable = Slice::Variable.new(json: @json.dig("variable")) if @json.dig("variable").present?
      render "slice/survey/page"
    else
      redirect_to page_slice_subject_path(@subject, params[:event], params[:design], @page)
    end
  end

  # GET /survey/:event/:design/complete
  def complete
    survey_completed
    render "slice/survey/complete"
    # redirect_to slice_surveys_path
  end

  private

  def set_subject
    @subject = current_user.subjects.find_by(id: params[:id])
  end

  def subject_params
    params.fetch(:subject, {}).permit(:project_id)
  end




  def find_user_survey
    # TODO: Implement
    # current_user.user_surveys.where(event: params[:event].downcase, design: params[:design].downcase).first_or_create
  end

  def survey_in_progress
    # TODO: Implement
    # find_user_survey.update(completed: false)
  end

  def survey_completed
    # TODO: Implement
    # find_user_survey.update(completed: true)
  end

  def find_page
    @page = [params[:page].to_i, 1].max
  end
end
