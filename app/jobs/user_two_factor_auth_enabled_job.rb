class UserTwoFactorAuthEnabled < ActiveJob::Base

  queue_as :user_two_factor_auth_enabled_job

  def perform user
    UserMailer.two_factor_auth_enabled(user).deliver_now
  end
end
