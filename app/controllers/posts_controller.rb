class PostsController < ApplicationController
	filter_resource_access
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]
	cache_sweeper :tree_sweeper

	def index
		load_tag if params[:acts_as_taggable_on_tag_id]
		before, after = Time.from_timestamp(params[:before]), Time.from_timestamp(params[:after])
		rev = after and not before
		p = Post
		if @tag then p = p.tagged_with(@tag) end
		if params[:year] then p = p.year_month(params[:year],params[:month]) end
		@posts = p.before_after(before, after) \
			.all(:order => rev ? 'created_at' : 'created_at DESC', :limit => PAGE_SIZE+1)
		@more = @posts.length > PAGE_SIZE
		@posts.slice!(PAGE_SIZE,1)
		@posts.reverse! if rev

		respond_to do |format|
			format.html # index.html.haml
			format.xml  { render :xml => @posts }
			format.json { render :json => @posts }
			format.atom
		end
	end

	def show
		respond_to do |format|
			format.html
			format.xml  { render :xml => @post }
			format.json { render :json => @post }
		end
	end

	def new
		respond_to do |format|
			format.html { render :edit  }
			format.xml  { render :xml => @post }
		end
	end

	def create
		respond_to do |format|
			if @post.save
				(User.find_all_by_mail_on_post(true).collect &:email).each do |e|
					Mailer.deliver_post(@post, e, polymorphic_url(@post,:secure=>false)) if e
				end
				flash[:notice] = 'Page was successfully created.'
				format.html { redirect_to(@post) }
				format.xml  { render :xml => @post, :status => :created, :location => @post }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @post.update_attributes(params[@post.class.name.underscore])
				(@post.comments.collect &:user).uniq.each do |u|
					Mailer.deliver_edit(@post, u.email, polymorphic_url(@post,:secure=>false)) if u.mail_on_edit and u.mailable?
				end
				flash[:notice] = 'Page was successfully updated.'
				format.html { redirect_to(@post) }
				format.xml  { head :ok }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@post.destroy

		respond_to do |format|
			format.html { redirect_to root_url }
			format.xml  { head :ok }
		end
	end
end
