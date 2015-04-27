=begin
To reset database, since global migrate does not create views for test database
```
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=test

```
=end

require 'simplecov'
require 'minitest/pride'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  setup :global_setup

  def global_setup
    Survey.refresh_all_surveys
  end
end

class ActionController::TestCase
  include Devise::TestHelpers

  def login(resource)
    @request.env["devise.mapping"] = Devise.mappings[resource]
    sign_in(resource.class.name.downcase.to_sym, resource)
  end

  def assert_authorization_exception
    assert_response 302
    assert flash[:alert]
  end
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user_template, password, email)
    user = User.create(password: password, password_confirmation: password, email: email,
                       first_name: user_template.first_name, last_name: user_template.last_name)
    user.save!
    user.update_column :deleted, user_template.deleted?
    post_via_redirect '/users/sign_in', user: { email: email, password: password }
    user
  end
end

module Rack
  module Test
    class UploadedFile
      def tempfile
        @tempfile
      end
    end
  end
end
