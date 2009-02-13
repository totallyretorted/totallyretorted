class TagRetortsController < ApplicationController
  before_filter :find_parent
  
  # GET /tag_retorts
  # GET /tag_retorts.xml
  def index
    params[:page] ||= 1
    @retorts = @tag.retorts.paginate :page => params[:page], :per_page => 25
    @listing = @retorts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retorts }
    end
  end

  # # GET /tag_retorts/1
  # # GET /tag_retorts/1.xml
  # def show
  #   @retort = @tag.retorts.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @retort }
  #   end
  # end
# 
  # # GET /tag_retorts/new
  # # GET /tag_retorts/new.xml
  # def new
  #   @tag_retort = TagRetort.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @tag_retort }
  #   end
  # end
# 
  # # GET /tag_retorts/1/edit
  # def edit
  #   @tag_retort = TagRetort.find(params[:id])
  # end
  # 
  # # POST /tag_retorts
  # # POST /tag_retorts.xml
  # def create
  #   @tag_retort = TagRetort.new(params[:tag_retort])
  # 
  #   respond_to do |format|
  #     if @tag_retort.save
  #       flash[:notice] = 'TagRetort was successfully created.'
  #       format.html { redirect_to(@tag_retort) }
  #       format.xml  { render :xml => @tag_retort, :status => :created, :location => @tag_retort }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @tag_retort.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /tag_retorts/1
  # # PUT /tag_retorts/1.xml
  # def update
  #   @tag_retort = TagRetort.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @tag_retort.update_attributes(params[:tag_retort])
  #       flash[:notice] = 'TagRetort was successfully updated.'
  #       format.html { redirect_to(@tag_retort) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @tag_retort.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /tag_retorts/1
  # # DELETE /tag_retorts/1.xml
  # def destroy
  #   @tag_retort = TagRetort.find(params[:id])
  #   @tag_retort.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(tag_retorts_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
private
  def find_parent
    @tag = Tag.find(params[:tag_id])
  end
end
