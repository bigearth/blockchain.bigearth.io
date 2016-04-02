class InfrastructureMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  default from: Figaro.env.mailer_sender
  
  def infrastructure_created config
    @config = config
    mail to: @user.email, subject: "Big Earth Infrastructure '#{@config['title']}' created!"
  end
  
  def infrastructure_destroyed config
    @config = config
    mail to: @user.email, subject: "Big Earth Infrastructure '#{@config['title']}' destroyed!"
  end
end
