#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Cmus; class Controller

class Toggle
	attr_reader :controller

	def initialize (controller)
		@controller = controller
	end

	# toggle the repeat status
	def repeat
		controller.puts 'toggle repeat'
	end

	# toggle the shuffle status
	def shuffle
		controller.puts 'toggle shuffle'
	end

	# toggle the pause status
	def pause
		controller.puts 'player-pause'
	end
end

end; end
