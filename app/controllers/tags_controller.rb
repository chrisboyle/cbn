class Tag < ActsAsTaggableOn::Tag; end  # use a sensible ivar name

class TagsController < ApplicationController
	filter_resource_access :context => :tags
	cache_sweeper :tree_sweeper

	def index
		@tags = Tag.all(:order => :name).select {|t| Post.tagged_with(t).present? or Project.tagged_with(t).present?}
		respond_to do |format|
			format.html
			format.pdf { @template.template_format = 'html'; render :pdf => 'tags' }
		end
	end

	def show
		@projects = Project.tagged_with(@tag).all(:order => :name)
		@posts = Post.tagged_with(@tag)
		if not has_role? :admin then @posts = @posts.by_draft(false) end
		@posts = @posts.all(:order => 'created_at DESC')
		respond_to do |format|
			format.html
			format.pdf { @template.template_format = 'html'; render :pdf => @tag.name }
		end
	end
end
