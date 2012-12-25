class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter( :provide_zombie_count )

	def provide_zombie_count
		@all_zombies_num = Zombie.count()
	end
end