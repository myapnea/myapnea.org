module ActiveRecord
  class LogSubscriber < ActiveSupport::LogSubscriber
    def sql(event)
      "#{event.payload[:name]} (#{event.duration}) #{event.payload[:sql]}"
    end
  end
end


if Rails.env.development?
  ActiveRecord::LogSubscriber.attach_to :active_record
end
