class UserMailer < ApplicationMailer
  include SendGrid
  sendgrid_category :use_subject_lines
  def welcome_email user
    sendgrid_category 'Welcome'
    @user = user
    @url  = 'http://stage.blockchain.bigearth.io/users/sign_in'
    mail to: @user.email, subject: 'Welcome to Big Earth!'
  end
end
