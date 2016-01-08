$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'preforker'
require 'rspec'
require 'rspec/autorun'
require 'rubygems'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |c|
end
