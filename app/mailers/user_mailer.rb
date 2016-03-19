class UserMailer < ApplicationMailer
  include SendGrid
  sendgrid_category :use_subject_lines
  def welcome_email(user)
    sendgrid_category "Welcome"
    puts "USER #{user.email}"
    @user = user
    @url  = 'http://stage.blockchain.bigearth.io/users/sessions/new'
    mail(to: @user.email, subject: 'Welcome to Big Earth!')
  end
end
