authorization do
	role :admin do
		has_permission_on [:users, :pages, :posts, :static_pages, :comments], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
	end
	role :guest do
		has_permission_on :pages, :to => [:index, :show]
	end
	role :known do
		includes :guest
		has_permission_on :comments, :to => [:new, :create]
		has_permission_on :comments, :to => [:edit, :update] do
			if_attribute :user => is { user }
		end
	end
	role :moderator do
		includes :known
		has_permission_on :comments, :to => :destroy
	end
end
