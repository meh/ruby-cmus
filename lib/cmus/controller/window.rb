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

class Window
	attr_reader :controller

	def initialize (controller)
		@controller = controller
	end

	def view (name)
		controller.send "view #{name}"
		controller.check_for_error

		self
	end

	def refresh
		controller.send 'refresh'

		self
	end

	def activate
		controller.send 'win-activate'

		self
	end

	def add (context = :playlist)
		controller.send "win-add-#{context.to_s.downcase[0]}"
		controller.check_for_error

		self
	end

	def bottom
		controller.send 'win-bottom'

		self
	end

	def down
		controller.send 'win-down'

		self
	end

	def up
		controller.send 'win-up'

		self
	end

	def top
		controller.send 'win-top'
		
		self
	end

	def move (whence = :after)
		controller.send "win-mv-#{whence}"
		controller.check_for_error

		self
	end

	def next
		controller.send 'win-next'

		self
	end

	def page_up
		controller.send 'win-page-up'

		self
	end

	def page_down
		controller.send 'win-page-down'

		self
	end

	def remove
		controller.send 'win-remove'

		self
	end

	def select_current
		controller.send 'win-sel-cur'

		self
	end

	def toggle
		controller.send 'win-toggle'

		self
	end

	def update
		controller.send 'win-update'

		self
	end

	def update_cache
		controller.send 'win-update-cache'

		self
	end

	def search (whence = :next)
		controller.send "search-#{whence}"
		controller.check_for_error

		self
	end
end

end; end
