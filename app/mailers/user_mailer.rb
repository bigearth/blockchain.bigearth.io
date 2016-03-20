class UserMailer < Devise::Mailer
  include SendGrid
  sendgrid_category :use_subject_lines
  
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  def confirmation_instructions user
    sendgrid_category 'Welcome'
    @user = user
    puts "Email: #{@user.email}"
    puts "Token: #{@user.confirmation_token}"
    @url  = confirmation_url @user
    puts "URL: #{@url}"
    mail to: @user.email, subject: 'Welcome to Big Earth!'
  end
end
