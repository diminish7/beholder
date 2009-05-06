task :test do
  path = File.expand_path(File.join(File.dirname(__FILE__), 'spec', 'test_*.rb'))
  system("ruby -S spec #{path}")
end