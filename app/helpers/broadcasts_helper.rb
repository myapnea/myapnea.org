# frozen_string_literal: true

# Pulls first image tag from description if one exists.
module BroadcastsHelper
  def first_image(broadcast)
    match = simple_markdown(broadcast.description, target_blank: false).match(/<img.*?>/m)
    match[0].to_s.html_safe if match
  end

  def first_image_url(broadcast)
    image = first_image(broadcast)
    if image
      match = image.match(/src="(.*?)"/)
      match[1].to_s if match
    end
  end
end
