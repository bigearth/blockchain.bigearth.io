class UserWelcomeJob < ActiveJob::Base

  queue_as :user_welcome_job

  def perform user
    puts 'USER WELCOME JOB CALLED'
    UserMailer.two_factor_auth_enabled(user).deliver_now
  end
end
