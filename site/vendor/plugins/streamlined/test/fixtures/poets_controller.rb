require "#{RAILS_ROOT}/app/controllers/application"
class PoetsController < ApplicationController
	acts_as_streamlined
	layout "streamlined"  # need this to test markup in the layouts
end