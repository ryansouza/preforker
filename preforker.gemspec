# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{preforker}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Cadenas"]
  s.date = %q{2010-04-02}
  s.description = %q{A gem to easily create prefork servers.}
  s.email = %q{dcadenas@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/amqp.rb",
     "examples/amqp_client.rb",
     "examples/ping_pong.rb",
     "lib/preforker.rb",
     "lib/preforker/pid_manager.rb",
     "lib/preforker/signal_processor.rb",
     "lib/preforker/util.rb",
     "lib/preforker/worker.rb",
     "spec/integration/logging_spec.rb",
     "spec/integration/timeout_spec.rb",
     "spec/integration/worker_control_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/support/integration.rb"
  ]
  s.homepage = %q{http://github.com/dcadenas/preforker}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A gem to easily create prefork servers.}
  s.test_files = [
    "spec/integration/logging_spec.rb",
     "spec/integration/timeout_spec.rb",
     "spec/integration/worker_control_spec.rb",
     "spec/spec_helper.rb",
     "spec/support/integration.rb",
     "examples/amqp.rb",
     "examples/amqp_client.rb",
     "examples/ping_pong.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<filetesthelper>, [">= 0.10.1"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<filetesthelper>, [">= 0.10.1"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<filetesthelper>, [">= 0.10.1"])
  end
end

