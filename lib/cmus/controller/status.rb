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
	class Song
		attr_reader   :controller, :tags
		attr_accessor :file, :position, :duration

		def initialize (controller)
			@tags = OpenStruct.new
		end

		%w[title artist album].each {|name|
			define_method name do
				tags.__send__ name
			end
		}

		def track
			tags.tracknumber
		end
	end

	attr_reader :controller, :song, :settings

	def initialize (controller)
		@controller = controller

		@song     = Song.new(controller)
		@settings = OpenStruct.new

		controller.send 'status'
		controller.wait_for_data.each_line {|line|
			type, data = line.chomp.split ' ', 2

			next unless type

			case type.to_sym
			when :status
				@status = case data.to_sym
					when :stopped then :STOP
					when :paused  then :PAUSE
					else               :PLAY
				end

			when :file
				@song.file = data

			when :duration
				@song.duration = data.to_i

			when :position
				@song.position = data.to_i

			when :tag
				name, data = data.split ' ', 2

				@song.tags.send "#{name}=", data

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

		@song = nil if self == :stop
	end

	def volume
		(settings.vol_left + settings.vol_right) / 2.0
	end

	def == (other)
		super || to_sym.downcase == other.to_sym.downcase
	end

	def to_sym
		@status
	end
end

end; end
