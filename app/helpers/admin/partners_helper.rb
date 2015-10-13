module Admin::PartnersHelper

  def partner_photo_url(partner)
    if partner.photo.present?
      photo_admin_partner_path(partner)
    else
      'default-user.jpg'
    end
  end

end
