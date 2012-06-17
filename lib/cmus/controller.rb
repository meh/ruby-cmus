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

	def clear (context = :playlist)
		puts "clear -#{context.to_s[0]}"
	end

	def add (context = :playlist, *paths)
		paths.flatten.compact.uniq.each {|path|
			puts "clear -#{context.to_s[0]} #{path}"
		}
	end

	def toggle
		Toggle.new(self)
	end

	def player
		Player.new(self)
	end

	def status
		Status.new(self)
	end
end

end
