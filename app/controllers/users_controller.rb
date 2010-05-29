class UsersController < ApplicationController
	filter_resource_access

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

	protected

	def load_user
		if params[:id] == 'current'
			@user = current_user
		else
			permitted_to! :show, User.new  # can't even access yourself by id
			@user = User.find(params[:id])
		end
	end
end
