class HomeController < ApplicationController
  def index
    @retorts = Retort.find(:all, :limit => 5)

    respond_to do |format|
      format.html # index.html.erb
      #format.xml { render :xml => @retorts.to_xml }
    end
  end
end
