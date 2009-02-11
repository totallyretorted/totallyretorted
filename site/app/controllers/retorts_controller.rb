require "rexml/document"

class RetortsController < ApplicationController
  before_filter :login_required, :only => [ :edit, :update, :create ]
  
  # GET /retorts
  # GET /retorts.xml
  def index
    # @retorts = Retort.find(:all)
    params[:page] ||= 1
    @retorts = Retort.paginate :page => params[:page]
    # @paginate = true
    @listing = @retorts

    respond_to do |format|
      format.html
      format.xml { render :xml => @retorts }
      #format.iphone # renders index.iphone.erb
    end
  end
  
  # def paginate
  #   @retorts = Retort.paginate :page => params[:page]
  #   @paginate = true
  #   @listing = @retorts
  # 
  #   respond_to do |format|
  #     format.html { render :action => 'index'}
  #     format.xml { render :xml => @retorts }
  #   end
  # end
    
  
  def screenzero
    @retorts = Retort.screenzero_retorts

    respond_to do |format|
      format.html
      format.xml { render :xml => @retorts.to_xml }
    end
  end

  # GET /retorts/1
  # GET /retorts/1.xml
  def show
    @retort = Retort.find(params[:id])
    @tagcloud = Tag.create_tagcloud(@retort.tags).sort_by{rand}
    @vote = Vote.find_by_retort_id_and_user_id(@retort, current_user)

    respond_to do |format|
      format.html
      format.xml { render :xml => @retorts.to_xml }
      #format.iphone # renders index.iphone.erb
    end
  end

  # GET /retorts/new
  # GET /retorts/new.xml
  def new
    @retort = Retort.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @retorts.to_xml }
    end
  end
  
  def new_remote
    @retort = Retort.new
    render :layout => false
  end

  # GET /retorts/1/edit
  def edit
    @retort = Retort.find(params[:id])
  end

  # POST /retorts
  # POST /retorts.xml
  def create
    @retort = Retort.new(params[:retort])
    # @retort.rating = Rating.new
    # @retort.rating.vote(true)
    @retort.votes << Vote.new(:user => current_user, :value => 1)
    unless params[:tags].nil? 
      params[:tags][:value].split(/,\s?/).each do |t|
        @retort.tags << Tag.find_or_create_by_value(t)
      end
    end
    unless params[:attribution].nil?
      @retort.attribution = Attribution.new(params[:attribution])
    end
    @retort.user = current_user

    respond_to do |format|
      format.html do
        if @retort.save
          flash[:notice] = 'Retort was successfully created'
          # redirect_to 'index'
          redirect_to(@retort)
        else
          flash[:error] = @retort.errors
          render :action => "new"
        end
      end
      format.xml do
        if @retort.save
          render :xml => @retort, :status => :created, :location => @retort
        else
          render :xml => @retort.erros, :status => :unprocessable_entity
        end
      end
      # format.iphone do
      # end
      # if @retort.save
      #        flash[:notice] = 'Retort was successfully created.'
      #        format.html { redirect_to(@retort) }
      #        format.xml { render :xml => @retort, :status => :created, :location => @retort }
      #        #format.iphone # renders index.iphone.erb
      #      else
      #        format.html { render :action => "new" }
      #        format.xml  { render :xml => @retort.errors, :status => :unprocessable_entity }
      #        #format.iphone # renders index.iphone.erb
      #      end
    end
  end

  # PUT /retorts/1
  # PUT /retorts/1.xml
  def update
    @retort = Retort.find(params[:id])

    respond_to do |format|
      if @retort.update_attributes(params[:retort])
        flash[:notice] = 'Retort was successfully updated.'
        format.html { redirect_to(@retort) }
        format.xml  { head :ok }
        #format.iphone # renders index.iphone.erb
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retort.errors, :status => :unprocessable_entity }
        #format.iphone # renders index.iphone.erb
      end
    end
  end

  # DELETE /retorts/1
  # DELETE /retorts/1.xml
  def destroy
    @retort = Retort.find(params[:id])
    @retort.destroy

    respond_to do |format|
      format.html { redirect_to(retorts_url) }
      format.xml  { head :ok }
      #format.iphone # renders index.iphone.erb
    end
  end
  
  
  def search
    unless params[:search].blank?
      @results = Retort.paginate :page => params[:page], 
                              :per_page => 10, 
                              # :include => [:rating],
                              :order => 'content ASC', 
                              :conditions => Retort.conditions_by_like(params[:search])
      logger.info @results.size
    end
    render :partial => 'search', :layout => false
  end    
end
