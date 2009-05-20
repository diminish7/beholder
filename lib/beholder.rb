require 'rubygems'
require "nokogiri"

dir = File.join(File.dirname(__FILE__), "beholder")

require File.join(dir, "exception.rb")
require File.join(dir, "node_utils.rb")
require File.join(dir, "logic_component.rb")
require File.join(dir, "parser.rb")
require File.join(dir, "view.rb")
