# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'history_tracker/version'

Gem::Specification.new do |spec|
  spec.name             = "history_tracker"
  spec.version          = HistoryTracker::VERSION
  spec.authors          = ["Chamnap Chhorn", "Morshed Alam"]
  spec.email            = ["chamnapchhorn@gmail.com", "morshed201@gmail.com"]
  spec.summary          = %q{Track changes}
  spec.description      = %q{Track changes of ActiveRecord models}
  spec.license          = "MIT"
  spec.extra_rdoc_files = ['README.md', 'LICENSE']

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end