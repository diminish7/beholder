require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'beholder')

#Get the full path to a test template
def template(name)
  File.join(File.dirname(__FILE__), "templates", name)
end

#Get rid of newlines and tabs from HTML
def strip_html(html)
  html.gsub(/\n|\t/, '')
end