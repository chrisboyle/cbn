class CommentsController < ApplicationController
	filter_resource_access :nested_in => :pages, :only => [:new,:create], :collection => []
	filter_resource_access :except => [:new,:create]
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]

	def index
		@comments = (has_role? :admin) ? Comment.all : Comment.all(:conditions => {:deleted => false}, :order => 'updated_at DESC')

		respond_to do |format|
			format.html
			format.xml  { render :xml => @comments }
		end
	end

	def show
		respond_to do |format|
			format.html { redirect_to url_for(@comment.page)+"#"+dom_id(@comment) }
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
				format.html { redirect_to @page }
				format.js
			else
				format.html { render :controller => :pages, :action => :show }
				format.js { render(:update) { |p| p.replace :add_comment, :partial => 'comments/edit' }}
			end
		end
	end

	def edit
		respond_to do |format|
			format.html
			format.js { render(:update) { |p| p.replace dom_id(@comment), :partial => 'comments/edit' }}
		end
	end

	def update
		respond_to do |format|
			if (params[:_commit] || params[:commit]) == 'Cancel'
				format.html { redirect_to @comment }
				format.js   { render(:update) {|p| p.replace dom_id(@comment), :partial => @comment }}
			elsif @comment.update_attributes(params[:comment])
				format.html do
					flash[:notice] = 'Comment was successfully updated.'
					redirect_to @comment
				end
				format.js
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.js   { render(:update) { |p| p.replace dom_id(@comment), :partial => 'comments/edit' }}
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
					p[@comment].fade
					if params[:has_count]
						p.replace 'comment_count', :partial => 'users/comment_count', :object => visible_comments(@comment.user)
					end
				end
			end
			format.xml  { head :ok }
		end
	end

	protected

	def new_comment_from_params
		@comment = Comment.new(params[:comment])
		@comment.identity_id = (params[:comment].delete(:identity_id) {|k| nil}) || (current_user && current_user.identity_id)
		@comment.page = @page
	end
end
