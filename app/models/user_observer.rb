class UserObserver < ActiveRecord::Observer
  def before_save
    UserMailer.welcome_email if self.confirmed_at_changed?
  end
end
