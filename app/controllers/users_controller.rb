class UsersController < ApplicationController
	filter_resource_access :additional_member => :delete_comments
	cache_sweeper :fragment_sweeper, :only => :delete_comments

	def index
		@users = User.all

		respond_to do |format|
			format.html
			format.xml  { render :xml => @users }
		end
	end

	def show
		respond_to do |format|
			format.html
			format.xml  { render :xml => @user }
		end
	end

	def update
		if has_role? :admin
			@user.role_ids = params[:user].delete(:role_ids) { |k| [] }
		end
		respond_to do |format|
			if @user.update_attributes(params[:user])
				flash[:notice] = 'Account successfully updated.'
				format.html { redirect_to @user }
				format.xml  { head :ok }
			else
				format.html { render :action => :show }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@user.destroy
		flash[:notice] = 'Account successfully deleted.'

		respond_to do |format|
			format.html { redirect_to root_url }
			format.xml  { head :ok }
		end
	end

	def delete_comments
		@user.comments.each &:destroy
		respond_to do |format|
			format.html { flash[:notice] = 'Comments successfully deleted.'; redirect_to @user }
			format.xml  { head :ok }
		end
	end
end
