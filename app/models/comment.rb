class Comment < ActiveRecord::Base
	belongs_to :page
	belongs_to :identity
	attr_accessible :body, :parent_id, :identity_id
	acts_as_nested_set :scope => :page_id

	# This could be done with using_access_control(:include_read) but this is faster
	named_scope :visible_to, lambda {|user| {:conditions => (user and user.role_symbols.include? :admin) ? nil : {:deleted => false}}}

	validates_presence_of :body
	validates_presence_of :identity
	validates_presence_of :page

	def user
		identity && identity.user
	end
end
