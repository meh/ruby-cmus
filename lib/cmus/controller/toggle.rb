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

	def toggle (name)
		controller.puts "toggle #{name}"

		self
	end

	def on (name)
		unless controller.status.settings.send(name)
			controller.puts "toggle #{name}"
		end

		self
	end

	def off (name)
		if controller.status.settings.send(name)
			controller.puts "toggle #{name}"
		end

		self
	end

	# toggle the repeat status
	def repeat
		toggle :Repeat
	end

	# enable repeat
	def repeat!
		on :Repeat
	end

	# disable repeat
	def no_repeat!
		off :Repeat
	end

	# toggle the shuffle status
	def shuffle
		toggle :Shuffle
	end

	# enable shuffle
	def shuffle!
		on :Shuffle
	end

	# disable shuffle
	def no_shuffle!
		off :Shuffle
	end

	# toggle the pause status
	def pause
		controller.puts 'player-pause'

		self
	end
end

end; end
