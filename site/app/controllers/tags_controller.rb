class TagsController < ApplicationController
  # before_filter :login_required, :only => [ :edit, :update, :create ]
  
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.find(:all, :order => "value ASC" )
    @alphabar = Tag.find_all_alphas
    #@tags = Tag.paginate :all, :page => params[:page], :order => "value ASC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag.to_xml({:deep => true}) }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to(@tag) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
    unless params[:search].blank?
      @results = Tag.paginate :page => params[:page], 
                              :per_page => 10, 
                              :order => 'value ASC', 
                              :conditions => Tag.conditions_by_like(params[:search])
      logger.info @results.size
    end
    render :partial => 'search', :layout => false
  end
  
  def alpha
    @letter = params[:letter]
    @tags = Tag.find_by_alpha(@letter)
    @alphabar = Tag.find_all_alphas
    @alphabar.delete(@letter)
    respond_to do |format|
      format.html{ render :action => "index" }
      format.xml { render :xml => @tags }
    end
  end

  # def paginate
  #    @tags = Tag.paginate :page => params[:page]
  #    @paginate = true
  #    @listing = @tags
  # 
  #    respond_to do |format|
  #      format.html { render :action => 'index'}
  #      format.xml { render :xml => @tags }
  #    end
  #  end
end
