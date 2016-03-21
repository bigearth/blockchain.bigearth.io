class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def before_save
    UserMailer.welcome_email if self.confirmed_at_changed?
  end
end
