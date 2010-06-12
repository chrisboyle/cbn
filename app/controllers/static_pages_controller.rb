class StaticPagesController < ApplicationController
	filter_resource_access
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]
	cache_sweeper :tree_sweeper

	def index
		@static_pages = StaticPage.all(:order => :title)

		respond_to do |format|
			format.html # index.html.haml
			format.xml  { render :xml => @static_pages }
			format.json { render :json => @static_pages }
			format.atom
		end
	end

	def show
		respond_to do |format|
			format.html
			format.xml  { render :xml => @static_page }
			format.json { render :json => @static_page }
		end
	end

	def new
		respond_to do |format|
			format.html { render :edit  }
			format.xml  { render :xml => @static_page }
		end
	end

	def create
		respond_to do |format|
			if @static_page.save
				flash[:notice] = 'Page was successfully created.'
				format.html { redirect_to @static_page }
				format.xml  { render :xml => @static_page, :status => :created, :location => @static_page }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @static_page.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @static_page.update_attributes(params[@static_page.class.name.underscore])
				flash[:notice] = 'Page was successfully updated.'
				format.html { redirect_to(@static_page) }
				format.xml  { head :ok }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @static_page.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@static_page.destroy

		respond_to do |format|
			format.html { redirect_to root_url }
			format.xml  { head :ok }
		end
	end
end
