require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the lazy_methods plugin.'
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_files = 'spec/**/*_spec.rb'
end

desc 'Generate documentation for the lazy_methods plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--title' << 'LazyMethods' << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |s| 
  s.name = "lazy_methods"
  s.version = "1.0.2"
  s.author = "Brian Durand"
  s.platform = Gem::Platform::RUBY
  s.summary = "Provide lazy method calls for all methods on every object to aid in caching."
  s.files = FileList["lib/**/*", "MIT-LICENSE", 'Rakefile'].to_a
  s.require_path = "lib"
  s.test_files = FileList["{spec}/**/*.rb"].to_a
  s.has_rdoc = true
  s.rdoc_options << '--title' << 'LazyMethods' << '--line-numbers' << '--inline-source' << '--main' << 'README'
  s.extra_rdoc_files = ["README"]
  s.homepage = "http://lazymethods.rubyforge.org"
  s.rubyforge_project = "lazymethods"
  s.email = 'brian@embellishedvisions.com'
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end

