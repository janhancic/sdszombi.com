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
		twitter_client.friendships( 'KPizda' )[0].connections.each do |status|
			if status === 'following'
				# user is not blocked
				redirect_to( not_blocked_path )
			end
		end

		# try to follow @strankaSDS
		follow_check = twitter_client.follow( 'KPizda' )

		if follow_check.length > 0
			# follow was successful, user is not blocked
			twitter_client.unfollow( 'KPizda' )
			redirect_to( not_blocked_path )
		else
			# user is blocked
			zombie = Zombie.find_by_name( session[:twitter_name] )
			if !zombie
				zombie = Zombie.create( :name => session[:twitter_name], :message => '', :show => true )
				redirect_to blocked_path( zombie, :created => true )
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

		@show_form = false

		if params[:created] && session[:twitter_name] && session[:twitter_name] == @zombie.name
			@show_form = true
		end
	end

  # GET /zombies/new
  # GET /zombies/new.json
  def new
    @zombie = Zombie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zombie }
    end
  end

  # GET /zombies/1/edit
  def edit
    @zombie = Zombie.find(params[:id])
  end

  # POST /zombies
  # POST /zombies.json
  def create
    @zombie = Zombie.new(params[:zombie])

    respond_to do |format|
      if @zombie.save
        format.html { redirect_to @zombie, notice: 'Zombie was successfully created.' }
        format.json { render json: @zombie, status: :created, location: @zombie }
      else
        format.html { render action: "new" }
        format.json { render json: @zombie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /zombies/1
  # PUT /zombies/1.json
  def update
    @zombie = Zombie.find(params[:id])

    respond_to do |format|
      if @zombie.update_attributes(params[:zombie])
        format.html { redirect_to @zombie, notice: 'Zombie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zombie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zombies/1
  # DELETE /zombies/1.json
  def destroy
    @zombie = Zombie.find(params[:id])
    @zombie.destroy

    respond_to do |format|
      format.html { redirect_to zombies_url }
      format.json { head :no_content }
    end
  end
end
