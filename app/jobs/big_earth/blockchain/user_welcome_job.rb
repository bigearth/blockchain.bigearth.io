module BigEarth 
  module Blockchain 
    class UserWelcomeJob < ActiveJob::Base

      queue_as :user_welcome_job

      def perform user
        UserMailer.welcome_email(user).deliver_later
      end
    end
  end
end
