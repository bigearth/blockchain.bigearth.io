class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  after_create :send_confirmation_instructions
  def send_confirmation_instructions
    UserMailer.confirmation_instructions(self).deliver_later
  end
end
