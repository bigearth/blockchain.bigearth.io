class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  before_save do
    if self.confirmed_at_changed?
      UserMailer.welcome_email(self).deliver_now
    end
    
    if self.authy_enabled_changed?
      UserMailer.two_factor_auth_enabled(self).deliver_now
    end
  end
end
