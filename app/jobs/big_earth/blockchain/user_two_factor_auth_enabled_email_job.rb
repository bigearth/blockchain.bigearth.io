module BigEarth 
  module Blockchain 
    class UserTwoFactorAuthEnabledEmailJob < ActiveJob::Base

      queue_as :user_two_factor_auth_enabled_email_job

      def perform user
        UserMailer.two_factor_auth_enabled(user).deliver_later
      end
    end
  end
end
