class HomeController < ApplicationController
  def index
    @retorts = Retort.screenzero_retorts

    respond_to do |format|
      format.html # index.html.erb
      #format.xml { render :xml => @retorts.to_xml }
    end
  end
end
