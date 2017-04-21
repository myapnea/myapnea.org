# frozen_string_literal: true

# Defines team members for team page.
class Admin::TeamMember < ApplicationRecord
  # Constants
  GROUPS = %w(steering internal patient)

  # Other macros
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable
end
