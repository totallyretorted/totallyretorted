# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # @failed = Builder::XmlMarkup.new().failed{ "invalid client type"}

  # render new.rhtml
  def new
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def verify
    respond_to do |format|
      format.html do
        redirect_to :action => "new"
      end
      format.xml do        
        authenticate_with_http_basic do |login, password|
          user = User.authenticate(login, password)
          if user
            render :xml => user, :status => :accepted
          else
            xml = Builder::XmlMarkup.new()
            xml.failed{
              xml.reason{
                "invalid credentials"
              }
            }
            render :xml => xml, :status => :not_acceptable
          end
        end
      end
    end
  end

  def create
    logout_keeping_session!
    # respond_to do |format|
    #   format.xml do
    #     xml = Builder::XmlMarkup.new()
    #     xml.failed{
    #       xml.reason{
    #         "invalid client type"
    #       }
    #     }
    #     render :xml => xml, :status => :forbidden
    #   end
    #   format.html do
        user = User.authenticate(params[:login], params[:password])
        if user
          # Protects against session fixation attacks, causes request forgery
          # protection if user resubmits an earlier form using back
          # button. Uncomment if you understand the tradeoffs.
          # reset_session
          self.current_user = user
      
          new_cookie_flag = (params[:remember_me] == "1")
          handle_remember_cookie! new_cookie_flag
          flash[:notice] = "Logged in successfully"
          redirect_back_or_default('/')
        else
          note_failed_signin
          @login       = params[:login]
          @remember_me = params[:remember_me]
          render :action => 'new'
        end
    #   end
    # end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
