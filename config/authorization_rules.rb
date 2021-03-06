privileges do
	privilege :manage, :includes => [:create, :read, :update, :delete]
	privilege :read,   :includes => [:index, :show]
	privilege :create, :includes => :new
	privilege :update, :includes => :edit
	privilege :delete, :includes => :destroy
end

authorization do
	role :guest do
		has_permission_on [:posts,:static_pages], :to => :read do
			if_attribute :draft => false
		end
		has_permission_on [:projects,:tags], :to => :read
		has_permission_on :comments, :to => :read, :join_by => :and do
			if_permitted_to :read, :post
			if_attribute :deleted => false, :approved => true
		end
	end
	role :commenter do
		has_permission_on :comments, :to => :create, :join_by => :and do
			if_permitted_to :read, :post
			if_attribute :user => is { user }, :deleted => false, :parent_deleted => false, :approved => is { engine.permit? :skip_moderation, :context => :comments, :user => user }
		end
		has_permission_on :comments, :to => [:update,:delete], :join_by => :and do
			if_permitted_to :read, :post
			if_attribute :user => is { user }, :deleted => false, :approved => true
		end
		has_permission_on :comments, :to => :reply, :join_by => :and do
			if_permitted_to :read
			if_attribute :deleted => false  # not implied by previous line for admins
		end
	end
	role :user do
		includes :guest, :commenter
		has_permission_on :users, :to => [:show,:update,:delete,:delete_comments] do
			if_attribute :id => is { user.id }
		end
	end
	role :known do
		has_permission_on :comments, :to => :skip_moderation
		has_permission_on :notifications, :to => :receive
	end
	role :moderator do
		has_permission_on :comments, :to => :approve do
			if_attribute :deleted => false, :approved => false
		end
		has_permission_on :comments, :to => :disapprove do
			if_attribute :deleted => false, :approved => true
		end
		has_permission_on :comments, :to => :trust do
			if_attribute :user => { :role_symbols => does_not_contain { :known } }, :deleted => false
		end
	end
	role :admin do
		includes :commenter
		has_permission_on [:users,:posts,:static_pages,:projects,:tags], :to => :manage
		has_permission_on :comments, :to => [:read,:delete]
	end
end
