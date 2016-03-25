ActiveJob::Base.queue_adapter = :resque
ActiveJob::Base.queue_name_prefix = Rails.env
