class PagesController < ApplicationController
  before_filter :authenticate, :except => [:index, :show, :find_by_month_and_name]

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @pages }
      format.json { render :json => @pages }
      format.atom
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @page }
      format.json { render :json => @page }
    end
  end

  def find_by_month_and_name
    start = Time.local(params[:year], params[:month])
    finish = start.end_of_month.end_of_day
    @page = Page.first(:conditions => ['created_at > ? and created_at < ? and name = ?', start, finish, params[:name]])

    respond_to do |format|
      format.html { render 'show' }
      format.xml  { render :xml => @page }
      format.json { render :json => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html { render 'edit' }
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

  private

  def authenticate
      authenticate_or_request_with_http_digest do |u|
          return "secret"
      end
  end
end
