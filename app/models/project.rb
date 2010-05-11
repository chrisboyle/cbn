class Project < ActiveRecord::Base
	def to_param
		return name
	end
end
