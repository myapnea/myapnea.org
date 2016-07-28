module Admin::TeamMembersHelper
  def team_member_photo_url(team_member)
    if team_member.photo.present?
      photo_admin_team_member_path(team_member)
    else
      'default-user.jpg'
    end
  end
end
