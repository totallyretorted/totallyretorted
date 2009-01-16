# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

#Mime.register_alias "text/html", :iphone

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd0d45df7f0c75fb208964cc608d96e47'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  before_filter :adjust_format_for_iphone

private
  def adjust_format_for_iphone
    if request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod)/]
      request.format = :iphone
    end
  end
end
