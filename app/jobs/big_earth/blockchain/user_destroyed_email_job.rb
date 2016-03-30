module BigEarth 
  module Blockchain 
    class UserDestroyedEmailJob < ActiveJob::Base

      queue_as :user_destroyed_email_job

      def perform email, chain_titles
        UserMailer.user_destroyed(email, chain_titles).deliver_later
      end
    end
  end
end
