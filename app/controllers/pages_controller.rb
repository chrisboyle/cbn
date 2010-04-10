class PagesController < ApplicationController
  before_filter :authenticate, :except => [:index, :show, :find_by_month_and_name]

  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @pages }
      format.json { render :json => @pages }
      format.atom
    end
  end

  def show
    @page = find_dated(params)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @page }
      format.json { render :json => @page }
    end
  end

  def new
    @page = Page.new
    respond_to do |format|
      format.html { render 'edit' }
      format.xml  { render :xml => @page }
    end
  end

  def edit
    @page = find_dated(params)
  end

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

  def find_dated(params)
    start = Time.local(params[:year], params[:month])
    finish = start.end_of_month.end_of_day
    Page.first(:conditions => ['created_at > ? and created_at < ? and name = ?', start, finish, params[:name]])
  end
end
