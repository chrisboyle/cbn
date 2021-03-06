class CommentsController < ApplicationController
	filter_resource_access :nested_in => :posts, :only => [:new,:create], :collection => []
	filter_resource_access :except => [:new,:create]
	cache_sweeper :fragment_sweeper, :only => [:update,:destroy]

	def index
		load_user if params[:user_id]
		@comments = (@post ? @post.comments : @user ? @user.comments : Comment).visible_to(current_user).all(:order => 'updated_at DESC', :limit => PAGE_SIZE)

		respond_to do |format|
			format.html do
				return redirect_to :controller => :posts, :action => :show, :anchor => 'comments' if @post
				return redirect_to :controller => :users, :action => :show, :id => (@user == current_user ? 'current' : @user.id), :anchor => 'comments' if @user
			end
			format.xml  { render :xml => @comments }
			format.pdf { @template.template_format = 'html'; render :pdf => 'comments' }
		end
	end

	def show
		respond_to do |format|
			format.html { return redirect_to comment_frag_url(@comment) }
			format.xml  { render :xml => @comment }
		end
	end

	def new
		respond_to do |format|
			format.html { return redirect_to :controller => :posts, :action => :show, :anchor => 'new_comment' }
			format.xml  { render :xml => @comment }
		end
	end

	def reply
		@post = @comment.post
		p = @comment
		@comment = @post.comment_from(current_user)
		@comment.parent = p
		no_cache
	end

	def create
		if not @comment.identity then raise "Anonymous comments are not allowed" end
		respond_to do |format|
			if (params[:_commit] || params[:commit]) == 'Cancel'
				format.html { return redirect_to @comment.post }
				format.js do
					if @comment.parent
						t = "reply_to_#{dom_id(@comment.parent)}"
						render(:update) {|p| p.visual_effect :blind_up, t, :afterFinish => p.literal("function(){$('#{t}').remove()}")}
					else
						render :nothing => true
					end
				end
			elsif @comment.save
				notify_comment(@comment, comment_frag_url(@comment))
				format.html { return redirect_to @post }
				format.js
			else
				format.html { render :controller => :posts, :action => :show }
				format.js { render(:update) { |p| p.replace( (@comment.parent_id ? "reply_to_#{dom_id(@comment.parent)}" : :new_comment), :partial => 'comments/edit') }}
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
				format.html { return redirect_to @comment }
				format.js   { render(:update) {|p| p.replace dom_id(@comment), :partial => @comment}}
			else
				@comment.attributes = params[:comment]
				@comment.updated_ip = request.remote_ip
				if @comment.save
					Role.find_by_name('admin').users.each do |a|
						Mailer.deliver_comment_admin(@comment, a.email, comment_frag_url(@comment), true) if a.mailable?
					end
					format.html do
						flash[:notice] = 'Comment was successfully updated.'
						return redirect_to @comment
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
	end

	def approve
		set_approved(true)
		notify_comment(@comment, comment_frag_url(@comment))
	end

	def trust
		u = @comment.user
		u.roles << Role.find_by_name('known')
		u.save!
		u.comments.each {|c| c.approved = true; c.save! }
		respond_to do |format|
			format.html { return redirect_to @comment }
			format.js { render(:update) {|p| p.redirect_to @comment }}
		end
	end

	def disapprove
		set_approved(false)
	end

	def destroy
		if @comment.deleted
			@comment.destroy
			deleted = true
		else
			@comment.update_attribute :deleted, true
			deleted = false
		end

		respond_to do |format|
			format.html { return redirect_to @comment.post }
			format.js do
				render :update do |p|
					if @comment.is_visible_to? current_user and not deleted and not params[:context]
						p.replace dom_id(@comment), :partial => @comment
						p[@comment].visual_effect :highlight, :endcolor => '#bbeeff'
					else
						c = @comment
						if params[:context]
							tree = dom_id(c)
						else
							while c.parent and not c.parent.is_visible_to? current_user do
								c = c.parent
							end
							tree = "replies_and_#{dom_id(c)}"
						end
						p.visual_effect :blind_up, tree, :afterFinish => p.literal("function(){$('#{tree}').remove()}")
					end
					if params[:context] == 'user'
						remaining = @comment.user.comments.visible_to(current_user)
						p.replace 'comment_count', :partial => 'users/comment_count', :object => remaining
						if remaining.empty?
							p['delete_all_comments'].remove
						end
					end
				end
			end
			format.xml  { head :ok }
		end
	end

	protected

	def comment_frag_url(c)
		return polymorphic_url(c.post,:secure=>false)+'#'+dom_id(c)
	end

	def new_comment_from_params
		params[:comment] ||= {}
		params[:comment][:identity_id] ||= (current_user && current_user.identity_id)
		@comment = Comment.new(params[:comment])
		@comment.post = @post
		@comment.approved = current_user && current_user.role_symbols.include?(:known)
		@comment.created_ip = @comment.updated_ip = request.remote_ip
	end

	def set_approved(a)
		begin
			# hack: this doesn't count as an edit
			Comment.record_timestamps = false
			@comment.approved = a
			respond_to do |format|
				if @comment.save
					format.html { return redirect_to @comment }
					format.js   { render(:update) {|p| p.replace dom_id(@comment), :partial => @comment}}
				else
					format.html { flash[:error] = 'Failed to update comment'; return redirect_to @comment }
					format.js   { render(:update) {|p| p.alert 'Failed to update comment' }}
				end
			end
		ensure
			Comment.record_timestamps = true
		end
	end

	def notify_comment(c, u)
		if c.approved
			mailed = {}
			Role.find_by_name('admin').users.each do |a|
				Mailer.deliver_comment_admin(c, a.email, u, false) if a.mailable?
				mailed[a] = true
			end
			if c.parent
				unsub = url_for(:controller => :users, :action => :show, :id => 'current', :secure => true)
				if c.parent.user != c.user and not mailed[c.parent.user] and c.parent.user.mail_on_reply
					Mailer.deliver_reply(c, c.parent.user.email, u, unsub) if c.parent.user.mailable?
					mailed[c.parent.user] = true
				end
				t = c.parent
				while t do
					if t.user != c.user and not mailed[t.user] and t.user.mail_on_thread
						Mailer.deliver_reply(c, t.user.email, u, unsub) if t.user.mailable?
						mailed[t.user] = true
					end
					t = t.parent
				end
			end
		else
			Role.find_by_name('moderator').users.each do |m|
				Mailer.deliver_moderator(c, m.email, u) if m.mailable?
			end
		end
	end
end
