class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  after_create :send_welcome_mail
  def send_welcome_mail
    UserMailer.welcome_email(self).deliver_later
  end
end
