# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{decouple}
  s.version = "0.0.1"

  s.date = %q{2014-03-10}
  s.authors = ["Sergei Zinin (einzige)"]
  s.email = %q{szinin@gmail.com}
  s.homepage = %q{http://github.com/einzige/decouple}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Decouples long methods in a pretty weird unnatural way. Please use PRIVATE methods instead. That's a really bad idea, NEVER use it.}
  s.summary = %q{Organizes your code by decoupling long methods into separate declarations}

  s.add_development_dependency 'rspec'
end

