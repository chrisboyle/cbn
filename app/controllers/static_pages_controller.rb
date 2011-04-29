class StaticPagesController < ApplicationController
	filter_resource_access
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]
	cache_sweeper :tree_sweeper

	def show
		respond_to do |format|
			format.html
			format.xml  { render :xml => @static_page }
			format.json { render :json => @static_page }
			format.pdf { @template.template_format = 'html'; render :pdf => @static_page.name }
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
				format.html { return redirect_to @static_page }
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
				format.html { return redirect_to(@static_page) }
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
			format.html { return redirect_to root_url }
			format.xml  { head :ok }
		end
	end

	protected

	def load_static_page
		@static_page = StaticPage.find_by_name(params[:name])
	end
end
