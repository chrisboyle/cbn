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
		respond_to do |format|
			format.html
			format.pdf { @template.template_format = 'html'; render :pdf => @tag.name }
		end
	end
end
