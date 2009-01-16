class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject += 'Please activate your new account'
  
    if ["development","test"].include?(ENV["RAILS_ENV"])
      host = "localhost:3000"
    else
      host = "www.totallyretorted.com"
    end
    @body[:url] = "http://#{host}/activate/#{user.activation_code}"
    
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://www.totallyretorted.com/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "admin@totallyretorted.com"
      @subject     = "Retorted Totally!"
      @sent_on     = Time.now
      @body[:user] = user
    end
end
