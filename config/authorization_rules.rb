privileges do
	privilege :manage, :includes => [:create, :read, :update, :delete]
	privilege :read,   :includes => [:index, :show]
	privilege :create, :includes => :new
	privilege :update, :includes => :edit
	privilege :delete, :includes => :destroy
end

authorization do
	role :guest do
		has_permission_on [:pages,:comments], :to => :read
	end
	role :user do
		includes :guest
		has_permission_on :users, :to => :update do
			if_attribute :id => is { user.id }
		end
		has_permission_on :comments, :to => :create do
			if_permitted_to :read, :page
		end
		has_permission_on :comments, :to => :update do
			if_attribute :user => is { user }
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
		has_permission_on [:users, :pages, :posts, :static_pages, :authorization_rules, :authorization_usages], :to => :manage
	end
end
