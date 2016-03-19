class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.mailer_sender
  layout 'mailer'
end
