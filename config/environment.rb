# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
ActionMailer::Base.smtp_settings = {
  user_name: Figaro.env.mailer_sender,
  password: Figaro.env.mailer_password,
  domain: Figaro.env.mailer_domain,
  address: Figaro.env.mailer_address,
  port: Figaro.env.mailer_port,
  authentication: :plain,
  enable_starttls_auto: true
}
