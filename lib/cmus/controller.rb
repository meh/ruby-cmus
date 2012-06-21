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

require 'cmus/controller/window'
require 'cmus/controller/toggle'
require 'cmus/controller/player'
require 'cmus/controller/status'

module Cmus

# This is the main class to manage cmus.
#
# The class also acts as a UNIXSocket if needed.
class Controller
	attr_reader :path

	def initialize (path = '~/.cmus/socket', timeout = 0.005)
		@path    = File.expand_path(path)
		@socket  = UNIXSocket.new(@path)
		@timeout = timeout
	end

	def respond_to_missing? (id)
		@socket.respond_to? id
	end

	def method_missing (id, *args, &block)
		@socket.__send__ id, *args, &block
	end

	def send (text)
		@socket.puts(text)

		self
	end

	def source (path)
		send "source #{File.realpath(File.expand_path(path))}"
		check_for_error

		self
	end

	def save
		send 'save'
	end

	def quit
		send 'quit'
	end

	def set (name, value)
		send "set #{name}=#{value}"
		check_for_error

		self
	end

	def set? (name)
		send "set #{name}"

		if text = check_for_error
			text[/=(.*?)'/, 1]
		end
	end

	def colorscheme (name)
		send "colorscheme #{name}"
		check_for_error

		self
	end

	# clear the context
	def clear (context = :playlist)
		send "clear -#{context.to_s[0]}"
		check_for_error

		self
	end

	# add a file to the context
	def add (context = :playlist, *paths)
		paths.flatten.compact.uniq.each {|path|
			send "add -#{context.to_s[0]} #{File.realpath(File.expand_path(path))}"
			check_for_error
		}

		self
	end

	def bind (context = :common, key, command)
		send "bind #{context} #{key} #{command}"
		check_for_error

		self
	end

	def bind! (context = :common, key, command)
		send "bind -f #{context} #{key} #{command}"
	end

	def unbind (context = :common, key)
		send "unbind #{context} #{key}"
		check_for_error

		self
	end
	
	def unbind! (context = :common, key)
		send "unbind -f #{context} #{key}"
	end

	def bind? (context = :common, key)
		send "showbind #{context} #{key}"

		if text = check_for_error
			Struct.new(:context, :key, :command).new(context, *text.split(' ')[2, 2])
		end
	end

	def mark (filter)
		send "mark #{filter}"
		check_for_error

		self
	end

	def unmark
		send 'unmark'
	end

	def update_cache
		send 'update-cache'
	end

	def echo (text)
		send "echo #{text}"
		check_for_error

		self
	end

	def filter (filter, live = false)
		send "#{'live-' if live}filter #{filter}"
		check_for_error

		self
	end

	def window
		@window ||= Window.new(self)
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

	def wait_for_data (timeout = @timeout)
		IO.select([@socket], nil, nil, timeout)

		buffer = ""

		while tmp = (@socket.read_nonblock(4096) rescue nil)
			buffer << tmp
		end

		buffer
	rescue
		nil
	end

	def check_for_error (data = nil)
		if error = data || wait_for_data and !error.strip.empty? && error.start_with?('Error:')
			raise ArgumentError, error.strip.split(/:\s*/, 2).last
		end

		error
	end
end

end
