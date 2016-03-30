module BigEarth 
  module Blockchain 
    class ChainDestroyedEmailJob < ActiveJob::Base

      queue_as :chain_destroyed_email_job

      def perform user, chain
        ChainMailer.chain_destroyed(user, chain).deliver_later
      end
    end
  end
end
