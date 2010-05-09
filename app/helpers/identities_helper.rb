module IdentitiesHelper
	def ident_select(f,identities)
		if identities.count == 1
			render(identities.first) + f.hidden_field(:identity_id)
		else
			f.select :identity_id, identities.collect { |i| ["[#{i.icon_and_text[0]}] #{i.icon_and_text[1]}",i.id] }
		end
	end
end
