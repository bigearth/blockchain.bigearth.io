class UserWelcomeJob < ActiveJob::Base

  queue_as :user_welcome_job

  def perform user
    puts 'USER WELCOME JOB CALLED'
    UserMailer.welcome_email(user).deliver_now
  end
end
