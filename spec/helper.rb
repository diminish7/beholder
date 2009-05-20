require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'beholder')

DOCTYPE = "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">" unless defined?(DOCTYPE)

#Get rid of newlines and tabs from HTML
def strip_html(html)
  html.gsub(/\n|\t/, '')
end