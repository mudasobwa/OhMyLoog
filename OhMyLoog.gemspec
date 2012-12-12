$:.push File.expand_path("../lib", __FILE__)
require 'OhMyLoog/version'

Gem::Specification.new do |s|
  s.name = 'OhMyLoog'
  s.version = Ohmyloog::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = '2012-12-12'
  s.authors = ['Alexei Matyushkin']
  s.email = 'am@mudasobwa.ru'
  s.homepage = 'http://github.com/mudasobwa/OhMyLoog'
  s.summary = %Q{One Hacking/Honestly More/Messing Yielding/Yawning Logger (Oodles Of Garbage)}
  s.description = %Q{Logger with an ability to colorize output if and only it’s being spitted on terminal and to examine the logs produced to yield possible errors.}
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'bueller'
end

