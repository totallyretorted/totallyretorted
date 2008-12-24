class TagsController < ApplicationController
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.find(:all, :order => "value ASC" )

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
  
  
      # 
      # <!-- <input id="search" name="search" type="text" value="">
      # <%= observe_field 'search',  :frequency => 0.5, :update => 'target_id', :url => { :controller => 'tags', :action=> 'search' }, :with => "'search=' + escape(value)" %>
      # <div class="search_results" id="target_id"></div> -->
  # def search
  #   if @params['search']
  #     #@items_pages, @items = paginate :items,:order_by => 'description',:conditions => [ 'LOWER(description) LIKE ?','%' + @params['search'].downcase + '%' ], :per_page => 20
  #     #@mark_term = @params['search']
  #     @tags_pages, @tags = paginate :tags, :order_by => 'value ASC', :conditions => ['LOWER(description) LIKE ?', '%'+@params['search'].downcase+'%'], :per_page => 20
  #     @mark_term = @params['search']
  #     render_without_layout
  #   else
  #     @tags_pages, @tags = paginate :tags, :order_by => 'value ASC', :per_page => 20
  #     #@items_pages, @items = paginate :items, :order_by => 'description', :per_page => 20
  #   end
  # end
end
