class Zombie < ActiveRecord::Base
  attr_accessible :message, :name, :secret, :show
end
