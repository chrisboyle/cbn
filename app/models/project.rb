class Project < ActiveRecord::Base
	acts_as_taggable

	def to_param
		name
	end
end
