class ChainMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  default from: Figaro.env.mailer_sender
  
  def chain_created user, chain
    @user = user
    @chain = chain
    mail to: user.email, subject: 'Big Earth Blockchain Account Confirmed!'
  end
  
  def chain_destroyed user, chain
    @user = user
    @chain = chain
    mail to: user.email, subject: 'Big Earth Blockchain 2 Factor Auth Enabled!'
  end
end
