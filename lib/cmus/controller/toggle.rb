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

	def repeat
		controller.puts 'toggle repeat'
	end

	def shuffle
		controller.puts 'toggle shuffle'
	end

	def pause
		controller.puts 'player-pause'
	end
end

end; end
