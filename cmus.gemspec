Kernel.load 'lib/cmus/version.rb'

Gem::Specification.new {|s|
	s.name         = 'cmus'
	s.version      = Cmus.version
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/ruby-cmus'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'cmus remote controller library.'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']
}
