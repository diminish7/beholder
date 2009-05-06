require 'rubygems'
require 'hpricot'

here = File.dirname(__FILE__)

Dir[File.join(here, "beholder", "*.rb")].each { |lib| require lib }