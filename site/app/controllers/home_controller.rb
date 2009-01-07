class HomeController < ApplicationController
  def index
    @retorts = Retort.screenzero_retorts
    @tagcloud = Tag.create_tagcloud.sort_by{rand}

    respond_to do |format|
      format.html
    end
  end
end
