module BigEarth 
  module Blockchain 
    class ChainCreatedEmailJob < ActiveJob::Base

      queue_as :chain_created_email_job

      def perform user, chain
        ChainMailer.chain_created(user, chain).deliver_later
      end
    end
  end
end
