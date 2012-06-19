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
		unless on? name
			controller.puts "toggle #{name}"
		end

		self
	end

	def off (name)
		if on? name
			controller.puts "toggle #{name}"
		end

		self
	end

	def on? (name)
		controller.status.settings.send(name) != false
	end

	# toggle the repeat status
	def repeat
		toggle :repeat
	end

	# enable repeat
	def repeat!
		on :repeat
	end

	# disable repeat
	def no_repeat!
		off :repeat
	end

	# get the repeat status
	def repeat?
		on? :repeat
	end

	# toggle the shuffle status
	def shuffle
		toggle :shuffle
	end

	# enable shuffle
	def shuffle!
		on :shuffle
	end

	# disable shuffle
	def no_shuffle!
		off :shuffle
	end

	# get the shuffle status
	def shuffle?
		on? :shuffle
	end

	# toggle the pause status
	def pause
		controller.puts 'player-pause'

		self
	end
end

end; end
