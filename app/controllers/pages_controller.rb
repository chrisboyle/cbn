class PagesController < ApplicationController
	filter_resource_access

	def index
		@pages = Post.all

		respond_to do |format|
			format.html # index.html.haml
			format.xml  { render :xml => @pages }
			format.json { render :json => @pages }
			format.atom
		end
	end

	def show
		respond_to do |format|
			format.html
			format.xml  { render :xml => @page }
			format.json { render :json => @page }
		end
	end

	def new
		respond_to do |format|
			format.html { render :edit  }
			format.xml  { render :xml => @page }
		end
	end

	def create
		respond_to do |format|
			if @page.save
				flash[:notice] = 'Page was successfully created.'
				format.html { redirect_to(@page) }
				format.xml  { render :xml => @page, :status => :created, :location => @page }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @page.update_attributes(params[@page.class.name.underscore])
				flash[:notice] = 'Page was successfully updated.'
				format.html { redirect_to(@page) }
				format.xml  { head :ok }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@page.destroy

		respond_to do |format|
			format.html { redirect_to(root_url) }
			format.xml  { head :ok }
		end
	end

	protected

	def new_page_from_params
		if params[:page]
			t = params[:page].delete('type')
			raise "Treason uncloaked!" unless %w(Post StaticPage).include?(t)
			@page = t.constantize.new(params[:page])
		else
			@page = Page.new
		end
	end
end
