class UserMailer < Devise::Mailer
  include SendGrid
  sendgrid_category :use_subject_lines
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: Figaro.env.mailer_sender
  
  def welcome_email user
    @user = user
    mail to: user.email, subject: 'Big Earth Blockchain Account Confirmed!'
  end
  
  def two_factor_auth_enabled user
    @user = user
    mail to: user.email, subject: 'Big Earth Blockchain 2 Factor Auth Enabled!'
  end
end
