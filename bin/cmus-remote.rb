#! /usr/bin/env ruby
require 'cmus'
require 'optparse'

options = {}

OptionParser.new do |o|
	o.on '--server SOCKET', 'connect using SOCKET instead of ~/.cmus/socket' do |value|
		options[:server] = value
	end

	o.on '--version', 'display version information and exit' do
		puts "cmus-remote.rb for #{Cmus.version}"
		exit
	end

	o.on '-p', '--play', 'start playing' do
		options[:player] = :play
	end

	o.on '-u', '--pause', 'toggle pause' do
		options[:player] = :pause
	end

	o.on '-s', '--stop', 'stop playing' do
		options[:player] = :stop
	end

	o.on '-n', '--next', 'skip forward in playlist' do
		options[:player] = :next
	end

	o.on '-r', '--prev', 'skip backward in playlist' do
		options[:player] = :prev
	end

	o.on '-v', '--volume VOL', 'changes volume' do |value|
		options[:player] = :volume
		options[:value]  = value
	end

	o.on '-k', '--seek SEEK', 'seek' do |value|
		options[:player] = :seek
		options[:value]  = value
	end

	o.on '-R', '--repeat', 'toggle repeat' do
		options[:toggle] = :repeat
	end

	o.on '-S', '--shuffle', 'toggle shuffle' do
		options[:toggle] = :shuffle
	end

	o.on '-Q', 'get player status information' do
		options[:status] = true
	end

	o.on '-l', '--library', 'modify library instead of playlist' do
		options[:library] = true
	end

	o.on '-P', '--playlist', 'modify playlist (default)' do
		options[:playlist] = true
	end

	o.on '-q', '--queue', 'modify play queue instead of playlist' do
		options[:queue] = true
	end

	o.on '-c', '--clear', 'clear playlist, library (-l) or play queue (-q)' do
		options[:clear] = true
	end

	o.on '-C', '--raw', 'treat arguments (instead of stdin) as raw commands' do
		options[:raw]
	end
end.parse!

controller = options[:server] ? Cmus::Controller.new(options[:server]) : Cmus::Controller.new

if options[:clear]
	controller.clear(options[:queue] ? :queue : options[:library] ? :library : :playlist)
end

if options[:player]
	controller.player.__send__ *[options[:player], options[:value]].compact
end

if options[:toggle]
	controller.toggle.__send__ options[:toggle]
end

if options[:status]
	controller.status.tap {|status|
		puts "status #{status.to_sym}"
		puts "file #{status.path}" if status.path
		puts "duration #{status.duration}" if status.duration
		puts "position #{status.position}" if status.position

		status.tags.marshal_dump.each {|name, value|
			puts "tag #{name} #{value}"
		}

		status.settings.marshal_dump.each {|name, value|
			puts "set #{name} #{value}"
		}
	}
end

if options[:raw]
	ARGV.each {|command|
		controller.puts command
	}

	while line = controller.readline
		puts line
	end
else
	ARGV.each {|path|
		controller.add(options[:queue] ? :queue : options[:library] ? :library : :playlist, path)
	}
end
