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

class Player
	attr_reader :controller

	def initialize (controller)
		@controller = controller
	end

	def play (file = nil)
		if file
			controller.puts "player-play #{File.real_path(File.expand_path(file))}"
		else
			controller.puts 'player-play'
		end
	end

	def pause
		return if controller.status == :paused

		controller.puts 'player-pause'
	end

	def stop
		controller.puts 'player-stop'
	end

	def next
		controller.puts 'player-next'
	end

	def prev
		controller.puts 'player-prev'
	end

	def volume (volume)
		controller.puts "vol #{volume}"
	end

	def seek (second)
		controller.puts "seek #{second}"
	end
end

end; end
