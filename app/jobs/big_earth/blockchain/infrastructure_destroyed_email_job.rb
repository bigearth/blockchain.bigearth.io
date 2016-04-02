module BigEarth 
  module Blockchain 
    class InfrastructureDestroyedEmailJob < ActiveJob::Base

      queue_as :infrastructure_destroyed_email_job

      def perform config
        InfrastructureMailer.infrastructure_destroyed(config).deliver_later
      end
    end
  end
end
