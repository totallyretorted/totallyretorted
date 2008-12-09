class RetortsController < ApplicationController
  # GET /retorts
  # GET /retorts.xml
  def index
    @retorts = Retort.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retorts }
    end
  end

  # GET /retorts/1
  # GET /retorts/1.xml
  def show
    @retort = Retort.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retort }
    end
  end

  # GET /retorts/new
  # GET /retorts/new.xml
  def new
    @retort = Retort.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retort }
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

    respond_to do |format|
      if @retort.save
        flash[:notice] = 'Retort was successfully created.'
        format.html { redirect_to(@retort) }
        format.xml  { render :xml => @retort, :status => :created, :location => @retort }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retort.errors, :status => :unprocessable_entity }
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
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retort.errors, :status => :unprocessable_entity }
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
    end
  end
end
