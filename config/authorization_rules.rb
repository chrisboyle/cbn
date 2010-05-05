privileges do
	privilege :manage, :includes => [:create, :read, :update, :delete]
	privilege :read,   :includes => [:index, :show]
	privilege :create, :includes => :new
	privilege :update, :includes => :edit
	privilege :delete, :includes => :destroy
end

authorization do
	role :guest do
		has_permission_on [:pages,:posts,:static_pages], :to => :read
		has_permission_on :comments, :to => :read do
			if_attribute :deleted => false
		end
	end
	role :user do
		includes :guest
		has_permission_on :users, :to => [:read,:update] do
			if_attribute :id => is { user.id }
		end
		has_permission_on :comments, :to => [:create,:update,:delete], :join_by => :and do
			if_attribute :deleted => false
			if_attribute :user => is { user }
			if_permitted_to :read, :page
		end
	end
	role :known do
		includes :user
	end
	role :moderator do
		includes :known
		has_permission_on :comments, :to => :delete
	end
	role :admin do
		has_omnipotence
	end
end
