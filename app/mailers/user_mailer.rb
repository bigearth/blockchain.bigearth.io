class UserMailer < Devise::Mailer
  include SendGrid
  sendgrid_category :use_subject_lines
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  
  def welcome_email user
    @user = user
    @url  = 'http://stageblockchain.bigearth.io/users/sign_in'
    @twofa = 'http://stageblockchain.bigearth.io/users/enable-two-factor'
    mail to: @user.email, subject: 'Big Earth account confirmed!'
  end
end
