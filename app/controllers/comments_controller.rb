class CommentsController < ApplicationController
	before_filter :load_page
	filter_resource_access :nested_in => :pages

	def index
		@comments = Comment.all

		respond_to do |format|
			format.html
			format.xml  { render :xml => @comments }
		end
	end

	def show
		respond_to do |format|
			format.html
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
		if not @comment.user then raise "Anonymous comments are not allowed" end
		respond_to do |format|
			if @comment.save
				#flash[:notice] = 'Comment was successfully created.'
				format.html { redirect_to(@page) }
				format.js
			else
				format.html { render :controller => :pages, :action => :show }
				format.js do
					render :update do |p|
						p.replace :new_comment, :partial => 'comments/new'
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
		@comment.destroy

		respond_to do |format|
			format.html { redirect_to(comments_url) }
			format.xml  { head :ok }
		end
	end

	protected

	def new_comment_from_params
		@comment = Comment.new(params[:comment])
		@comment.user = current_user
	end
end
