module ApplicationHelper
	def full_page_title( title )
		if title.blank? then
			'SDS Zombi'
		else
			title + ' - SDS Zombi'
		end
	end
end