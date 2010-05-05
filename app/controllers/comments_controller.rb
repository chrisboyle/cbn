class CommentsController < ApplicationController
	filter_resource_access :nested_in => :pages, :only => [:new,:create]
	filter_resource_access :except => [:new,:create]

	def index
		@comments = (has_role? :admin) ? Comment.all : Comment.all(:conditions => {:deleted => false})

		respond_to do |format|
			format.html
			format.xml  { render :xml => @comments }
		end
	end

	def show
		respond_to do |format|
			format.html { redirect_to url_for(@comment.page)+"#comment_#{@comment.id}" }
			format.xml  { render :xml => @comment }
		end
	end

	def new
		respond_to do |format|
			format.html { redirect_to :controller => :pages, :action => :show, :anchor => 'addcomment' }
			format.xml  { render :xml => @comment }
		end
	end

	def create
		if not @comment.identity then raise "Anonymous comments are not allowed" end
		respond_to do |format|
			if @comment.save
				#flash[:notice] = 'Comment was successfully created.'
				format.html { redirect_to(@page) }
				format.js
			else
				format.html { render :controller => :pages, :action => :show }
				format.js do
					render :update do |p|
						p.replace :new_comment, :partial => 'comments/edit'
					end
				end
			end
		end
	end

	def update
		respond_to do |format|
			if @comment.update_attributes(params[:comment])
				flash[:notice] = 'Comment was successfully updated.'
				format.html { redirect_to(@comment) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@comment.deleted = true
		@comment.save

		respond_to do |format|
			format.html { redirect_to @comment.page }
			format.js do
				render :update do |p|
					p["comment_#{@comment.id}"].fade
				end
			end
			format.xml  { head :ok }
		end
	end

	protected

	def new_comment_from_params
		@comment = Comment.new(params[:comment])
		@comment.page = @page
		@comment.identity ||= current_user && current_user.identity
	end
end
