# frozen_string_literal: true

# Displays team member photo.
module TeamMembersHelper
  def team_member_photo_tag(team_member, size: 128, style: nil)
    image_tag(
      team_member_photo_path(team_member),
      alt: "",
      class: "img-ignore-selection team-member-picture",
      size: "#{size}x#{size}",
      style: "height: #{size}px;width: #{size}px;#{style}"
    )
  end
end
