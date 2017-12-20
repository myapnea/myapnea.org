# frozen_string_literal: true

# Allows users to consent and get added to active studies.
class Slice::SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

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
      redirect_to slice_research_path, notice: "Subject was successfully created."
    else
      render :new
    end
  end

  # PATCH /slice/subjects/1
  def update
    if @subject.update(subject_params)
      redirect_to slice_research_path, notice: "Subject was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /slice/subjects/1
  def destroy
    @subject.destroy
    redirect_to slice_research_path, notice: "Subject was successfully deleted."
  end

  private

  def set_subject
    @subject = current_user.subjects.find_by(id: params[:id])
  end

  def subject_params
    params.fetch(:subject, {}).permit(:project_id)
  end
end
