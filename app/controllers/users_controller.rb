class UsersController < ApplicationController
	filter_resource_access

	def index
		@users = User.all

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @users }
		end
	end

	def show
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @user }
		end
	end

	def update
		respond_to do |format|
			if @user.update_attributes(params[:user])
				flash[:notice] = 'User was successfully updated.'
				format.html { redirect_to(@user) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	def destroy
		@user.destroy

		respond_to do |format|
			format.html { redirect_to(users_url) }
			format.xml  { head :ok }
		end
	end

	protected

	def load_user
		if params[:id] == 'current'
			@user = current_user
		else
			permitted_to! :show, User.new
			@user = User.find(params[:id])
		end
	end
end
