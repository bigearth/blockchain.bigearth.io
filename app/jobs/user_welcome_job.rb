class UserWelcomeJob < ActiveJob::Base

  queue_as :user_welcome_job

  def perform user
    UserMailer.welcome_email(user).deliver_now
  end
end
