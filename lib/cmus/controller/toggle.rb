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
		controller.send "toggle #{name}"

		self
	end

	def on (name)
		unless on? name
			controller.send "toggle #{name}"
		end

		self
	end

	def off (name)
		if on? name
			controller.send "toggle #{name}"
		end

		self
	end

	def on? (name)
		controller.status.settings.send(name)
	end

	%w[show_hidden continue play_library repeat_current aaa_mode play_sorted repeat shuffle show_remaining_time].each {|name|
		option_name = name

		define_method name do
			toggle option_name
		end

		define_method "#{name}!" do
			on option_name
		end

		define_method "no_#{name}!" do
			off option_name
		end

		define_method "#{name}?" do
			on? option_name
		end
	}


	# toggle the pause status
	def pause
		controller.send 'player-pause'

		self
	end
end

end; end
