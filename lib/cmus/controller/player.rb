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

	# play the current selection or the passed file
	def play (file = nil)
		if file
			controller.send "player-play #{File.real_path(File.expand_path(file))}"
		else
			controller.send 'player-play'
		end

		self
	end

	# pause the current song
	def pause
		return self if controller.status == :paused

		controller.send 'player-pause'

		self
	end

	# unpause the current song
	def unpause
		return self unless controller.status == :paused

		controller.send 'player-pause'

		self
	end

	# stop the current song
	def stop
		controller.send 'player-stop'

		self
	end

	# go to the next song in the playlist
	def next
		controller.send 'player-next'

		self
	end

	# go to the previous song in the playlist
	def prev
		controller.send 'player-prev'

		self
	end

	# change the volume
	def volume (volume)
		controller.send "vol #{volume}"
		controller.check_for_error

		self
	end

	# seek to the passed second
	def seek (second)
		controller.send "seek #{second}"
		controller.check_for_error

		self
	end
end

end; end
