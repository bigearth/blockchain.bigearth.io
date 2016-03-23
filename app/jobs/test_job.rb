class TestJob < ActiveJob::Base

  queue_as :test_job

  def perform tmp
    5.times do |x|
      puts x
      sleep 1
    end
  end
end
