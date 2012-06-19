#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'socket'

require 'cmus/controller/toggle'
require 'cmus/controller/player'
require 'cmus/controller/status'

module Cmus

# This is the main class to manage cmus.
#
# The class also acts as a UNIXSocket if needed.
class Controller
	attr_reader :path

	def initialize (path = '~/.cmus/socket')
		@path   = File.expand_path(path)
		@socket = UNIXSocket.new(@path)
	end

	def respond_to_missing? (id)
		@socket.respond_to? id
	end

	def method_missing (id, *args, &block)
		@socket.__send__ id, *args, &block
	end

	# clear the context
	def clear (context = :playlist)
		puts "clear -#{context.to_s[0]}"
	end

	# add a file to the context
	def add (context = :playlist, *paths)
		paths.flatten.compact.uniq.each {|path|
			puts "clear -#{context.to_s[0]} #{path}"
		}
	end

	# returns the toggle facilities
	def toggle
		@toggle ||= Toggle.new(self)
	end

	# returns the player facilities
	def player
		@player ||= Player.new(self)
	end

	# returns the status
	def status
		Status.new(self)
	end
end

end
