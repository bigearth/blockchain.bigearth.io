module BigEarth 
  module Blockchain 
    class UserDestroyedEmailJob < ActiveJob::Base

      queue_as :user_destroyed_email_job

      def perform email
        UserMailer.user_destroyed(email).deliver_later
      end
    end
  end
end
