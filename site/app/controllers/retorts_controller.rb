class RetortsController < ApplicationController
  # GET /retorts
  # GET /retorts.xml
  def index
    @retorts = Retort.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => Retort.to_full_xml(@retort)}
      #format.iphone # renders index.iphone.erb
    end
  end

  # GET /retorts/1
  # GET /retorts/1.xml
  def show
    @retort = Retort.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
#      format.xml  { render :xml => @retort.to_xml({:include => [ :tags, :attribution, :rating ]}) }
#      format.xml  { render :xml => @retort.to_xml {:include => [ :tags, :attribution, :rating ] } }
      #format.xml { render :xml => @retort.to_xml(:include => [ :tags ], :except => [:retort_id, :tag_id, :created_at, :updated_at] )}
      format.xml { render :xml => Retort.to_full_xml(@retort)}
      #format.iphone # renders index.iphone.erb
    end
  end

  # GET /retorts/new
  # GET /retorts/new.xml
  def new
    @retort = Retort.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => Retort.to_full_xml(@retort)}
      #format.iphone # renders index.iphone.erb
    end
  end

  # GET /retorts/1/edit
  def edit
    @retort = Retort.find(params[:id])
  end

  # POST /retorts
  # POST /retorts.xml
  def create
    @retort = Retort.new(params[:retort])
    params[:tags][:value].split.each do |t|
      @retort.tags << Tag.new(:value => t) unless Tag.find_by_value(t)
    end

    respond_to do |format|
      if @retort.save
        flash[:notice] = 'Retort was successfully created.'
        format.html { redirect_to(@retort) }
        format.xml  { render :xml => Retort.to_full_xml(@retort, :status => :created, :location => @retort) }
        #format.iphone # renders index.iphone.erb
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retort.errors, :status => :unprocessable_entity }
        #format.iphone # renders index.iphone.erb
      end
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
end
