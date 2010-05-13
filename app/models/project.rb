class Project < ActiveRecord::Base
	acts_as_taggable
	validates_presence_of :title, :body
	STATUSES = %w( idea planning active maintenance abandoned )
	validates_inclusion_of :status, :in => STATUSES

	def to_param
		name
	end
end
