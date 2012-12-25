class ZombiesController < ApplicationController
	def index
		@zombies = Zombie.all()
	end

	def not_blocked
	end

	def twitter_callback
		session[:twitter_name] = request.env['omniauth.auth']['info']['nickname']
		session[:twitter_token] = request.env['omniauth.auth']['credentials']['token']
		session[:twitter_secret] = request.env['omniauth.auth']['credentials']['secret']

		redirect_to( check_block_status_path )
	end

	def check_block_status
		redirect_to( root_path ) unless session[:twitter_token] && session[:twitter_secret]

		twitter_client = Twitter::Client.new(
			:oauth_token => session[:twitter_token],
			:oauth_token_secret => session[:twitter_secret]
		)

		# check if user is following @strankaSDS
		is_following = false
		twitter_client.friendships( 'strankaSDS' )[0].connections.each do |status|
			if status === 'following'
				# user is not blocked
				redirect_to( not_blocked_path )
			end
		end

		# try to follow @strankaSDS
		follow_check = twitter_client.follow( 'strankaSDS' )

		if follow_check.length > 0
			# follow was successful, user is not blocked
			twitter_client.unfollow( 'strankaSDS' )
			redirect_to( not_blocked_path )
		else
			# user is blocked
			zombie = Zombie.find_by_name( session[:twitter_name] )
			if !zombie
				zombie = Zombie.create( :name => session[:twitter_name], :message => '', :show => true )
				redirect_to blocked_path( zombie )
			else
				redirect_to blocked_path( zombie )
			end
		end
	end

	def show
		begin
			@zombie = Zombie.find( params[:id] )
		rescue
			redirect_to( root_path )
		end

		@show_form = ( session[:twitter_name] && session[:twitter_name] == @zombie.name )
	end

	def update
		@zombie = Zombie.find( params[:id] )

		new_message = params[:zombie][:message]
		if new_message.length > 140
			new_message = new_message[0..139]
		end

		if @zombie.update_attributes( message: new_message )
			redirect_to( blocked_path( @zombie ) )
		else
			redirect_to( root_path )
		end
	end
end