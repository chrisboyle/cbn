class Comment < ActiveRecord::Base
	belongs_to :post
	belongs_to :identity
	attr_accessible :body, :parent_id, :identity_id
	acts_as_nested_set :scope => :post_id
	validates_presence_of :body
	validates_length_of :body, :maximum => 3000
	validates_presence_of :identity
	validates_presence_of :post
	validate do |c|
		errors.add_to_base("Invalid parent comment") if c.parent and (c.parent.post_id != c.post_id or c.parent_id == c.id)
	end

	# This could be done with using_access_control(:include_read) but this is faster
	named_scope :visible_to, lambda {|user| {:conditions => (user and user.role_symbols.include? :admin) ? nil : {:deleted => false, :approved => true}}}

	def is_visible_to?(user)
		(user and user.role_symbols.include? :admin) or (approved and (not deleted or descendants.any? {|c| c.approved and not c.deleted}))
	end

	def parent_deleted
		parent ? parent.deleted : false
	end

	def user
		identity && identity.user
	end
end
