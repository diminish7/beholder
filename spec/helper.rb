require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'beholder')

#Get rid of newlines and tabs from HTML
def strip_html(html)
  html.gsub(/\n|\t/, '')
end