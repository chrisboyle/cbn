class PostsController < ApplicationController
	filter_resource_access
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]
	cache_sweeper :tree_sweeper

	def index
		# Wordpress hack
		p = params[:p]
		if request.path == '/' and p
			return redirect_to ((p.to_i<0) ? StaticPage.find(-1*p.to_i) : Post.find(p)), :status => :moved_permanently
		end

		load_tag if params[:acts_as_taggable_on_tag_id]
		before, after = Time.from_timestamp(params[:before]), Time.from_timestamp(params[:after])
		rev = after and not before
		p = Post
		if @tag then p = p.tagged_with(@tag) end
		if not has_role? :admin then p = p.by_draft(false) end
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
			format.pdf { @template.template_format = 'html'; render :pdf => params[:year] ? params[:month] ? "#{params[:year]}-#{params[:month]}" : "#{params[:year]}" : 'posts' }
		end
	end

	def show
		respond_to do |format|
			format.html
			format.xml  { render :xml => @post }
			format.json { render :json => @post }
			format.pdf { @template.template_format = 'html'; render :pdf => @post.name }
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
				unsub = url_for(:controller => :users, :action => :show, :id => 'current', :secure => true)
				User.find_all_by_mail_on_post(true).each do |u|
					Mailer.deliver_post(@post, u.email, polymorphic_url(@post,:secure=>false), unsub) if u.mailable?
				end
				flash[:notice] = 'Page was successfully created.'
				format.html { return redirect_to(@post) }
				format.xml  { render :xml => @post, :status => :created, :location => @post }
			else
				format.html { render :action => :edit }
				format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			was_draft = @post.draft?
			@post.attributes = params[@post.class.name.underscore]
			if was_draft and not @post.draft? then
				@post.created_at = @post.updated_at = Time.now
			end
			if @post.save
				unsub = url_for(:controller => :users, :action => :show, :id => 'current', :secure => true)
				(@post.comments.collect &:user).uniq.each do |u|
					Mailer.deliver_edit(@post, u.email, polymorphic_url(@post,:secure=>false), unsub) if u.mail_on_edit and u.mailable?
				end
				flash[:notice] = 'Page was successfully updated.'
				format.html { return redirect_to(@post) }
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
			format.html { return redirect_to root_url }
			format.xml  { head :ok }
		end
	end
end
