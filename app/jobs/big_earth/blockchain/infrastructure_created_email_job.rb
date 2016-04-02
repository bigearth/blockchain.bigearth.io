module BigEarth 
  module Blockchain 
    class InfrastructureCreatedEmailJob < ActiveJob::Base

      queue_as :infrastructure_created_email_job

      def perform config
        InfrastructureMailer.infrastructure_created(config).deliver_later
      end
    end
  end
end
