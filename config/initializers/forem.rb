require 'emoji'
Forem.user_class = "User"
Forem.main_layout = "main"
Forem.admin_layout = "admin"
Forem.logged_in_layout = "main"
Forem.avatar_user_method = :photo_url
Forem.email_from_address = "#{ENV['website_name']} <#{ENV['smtp_email']}>"
Forem.per_page = 20


module Forem
  class NilUser
    def photo_url
      "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest("NilUser")}?d=identicon"
    end
  end
end
