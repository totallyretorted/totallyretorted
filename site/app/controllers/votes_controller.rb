class VotesController < ApplicationController
  before_filter :find_retort
  
  # GET /votes
  # GET /votes.xml
  def index
    @votes = @retort.votes.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.xml
  def show
    @vote = @retort.votes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.xml
  def new
    @vote = @retort.votes.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = @retort.votes.find(params[:id])
  end

  # POST /votes
  # POST /votes.xml
  def create
    @vote = @retort.votes.new(params[:vote])
    @vote.user = current_user

    respond_to do |format|
      if @vote.save
        flash[:notice] = 'Vote was successfully created.'
        format.html { redirect_to([@retort, @vote]) }
        format.xml  { render :xml => @vote, :status => :created, :location => [@retort, @vote] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = @retort.votes.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to([@retort, @vote]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.xml
  def destroy
    @vote = @retort.votes.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(retort_votes_url(@retort)) }
      format.xml  { head :ok }
    end
  end
  
private 
  def find_retort 
    @retort = Retort.find(params[:retort_id]) 
  end 
end
