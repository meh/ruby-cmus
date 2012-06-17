#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'ostruct'

module Cmus; class Controller

class Status
	attr_reader :controller, :path, :duration, :position, :tags, :settings

	def initialize (controller)
		@controller = controller

		@tags     = OpenStruct.new
		@settings = OpenStruct.new

		controller.puts 'status'

		buffer = controller.read(1)

		while tmp = (controller.read_nonblock(2048) rescue nil)
			buffer << tmp
		end
		
		buffer.each_line {|line|
			type, data = line.chomp.split ' ', 2

			next unless type

			case type.to_sym
			when :status
				@status = data.to_sym

			when :file
				@path = data

			when :duration
				@duration = data.to_i

			when :position
				@position = data.to_i

			when :tag
				name, data = data.split ' ', 2

				@tags.send "#{name}=", data

			when :set
				name, data = data.split ' ', 2

				@settings.send "#{name}=", data
			end
		}
	end

	def == (other)
		super || to_sym == other
	end

	def to_sym
		@status
	end
end

end; end
