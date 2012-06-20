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
	attr_reader :controller, :path, :duration, :position, :song, :settings

	def initialize (controller)
		@controller = controller

		@song     = OpenStruct.new
		@settings = OpenStruct.new

		controller.send 'status'
		controller.wait_for_data.buffer.each_line {|line|
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

				@song.send "#{name}=", data

			when :set
				name, data = data.split ' ', 2

				data = if data == 'false'
					false
				elsif data == 'true'
					true
				elsif (Integer(data) rescue false)
					data.to_i
				elsif (Float(data) rescue false)
					data.to_f
				else
					data
				end

				@settings.send "#{name}=", data
			end
		}

		if @song.marshal_dump.empty?
			@song = nil
		end
	end

	def volume
		(settings.vol_left + settings.vol_right) / 2.0
	end

	def == (other)
		super || to_sym == other
	end

	def to_sym
		@status
	end
end

end; end
