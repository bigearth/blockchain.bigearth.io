class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  has_many :chains, dependent: :destroy
  accepts_nested_attributes_for :chains
  devise :authy_authenticatable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable 
         
  before_save do
    if self.confirmed_at_changed?
      UserMailer.welcome_email(self).deliver_now
    end
    
    if self.authy_enabled_changed?
      UserWelcomeJob.perform_later self
    end
  end
end
