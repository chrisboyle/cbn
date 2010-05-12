class Tag < ActsAsTaggableOn::Tag; end  # use a sensible ivar name

class TagsController < ApplicationController
	filter_resource_access :context => :tags

	def index
		@tags = Tag.all(:order => :name)
	end

	protected

	def load_tag
		@tag = Tag.find_by_name(params[:id])
	end
end
