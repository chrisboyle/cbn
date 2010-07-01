class ProjectsController < ApplicationController
	filter_resource_access
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]
	cache_sweeper :tree_sweeper

	def index
		@projects = Project.all(:order => :name)

		respond_to do |format|
			format.html
			format.xml { render :xml => @projects }
			format.pdf { @template.template_format = 'html'; render :pdf => 'projects' }
		end
	end

	def show
		respond_to do |format|
			format.html
			format.xml { render :xml => @project }
			format.pdf { @template.template_format = 'html'; render :pdf => @project.name }
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
			if @project.save
				flash[:notice] = 'Project was successfully created.'
				format.html { redirect_to @project }
				format.xml  { render :xml => @project, :status => :created, :location => @project }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		p = params[:project]
		# Hack to allow setting a date to nil - TODO find a better way
		if p['start(1i)'].blank? and p['start(2i)'].blank? then p['start(3i)'] = '' end
		if p['end(1i)'].blank? and p['end(2i)'].blank? then p['end(3i)'] = '' end
		respond_to do |format|
			if @project.update_attributes(p)
				flash[:notice] = 'Project was successfully updated.'
				format.html { redirect_to(@project) }
				format.xml  { head :ok }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@project.destroy

		respond_to do |format|
			format.html { redirect_to projects_url }
			format.xml  { head :ok }
		end
	end

	protected

	def load_project
		@project = Project.find_by_name(params[:id])
	end
end
