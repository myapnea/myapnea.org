# frozen_string_literal: true

# Allows users to access Slice surveys.
class SliceController < ApplicationController
  before_action :authenticate_user!

  # # GET /slice/surveys
  # def surveys
  # end
end
