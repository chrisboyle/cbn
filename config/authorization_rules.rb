privileges do
	privilege :manage, :includes => [:create, :read, :update, :delete]
	privilege :read,   :includes => [:index, :show]
	privilege :create, :includes => :new
	privilege :update, :includes => :edit
	privilege :delete, :includes => :destroy
end

authorization do
	role :guest do
		has_permission_on [:pages,:posts,:static_pages,:projects,:tags], :to => :read
		has_permission_on :comments, :to => :read do
			if_attribute :deleted => false
		end
	end
	role :commenter do
		has_permission_on :comments, :to => [:create,:update,:delete], :join_by => :and do
			if_attribute :deleted => false
			if_attribute :user => is { user }
			if_permitted_to :read, :page
		end
		has_permission_on :comments, :to => :reply, :join_by => :and do
			if_attribute :deleted => false
			if_permitted_to :read, :page
		end
	end
	role :user do
		includes :guest, :commenter
		has_permission_on :users, :to => [:show,:update,:delete] do
			if_attribute :id => is { user.id }
		end
	end
	role :known do
		includes :user
	end
	role :moderator do
		includes :known
		has_permission_on :comments, :to => :delete do
			if_attribute :deleted => false
		end
	end
	role :admin do
		includes :commenter
		has_permission_on [:users,:pages,:posts,:static_pages,:projects,:tags], :to => :manage
		has_permission_on :comments, :to => [:read,:delete]
	end
end
