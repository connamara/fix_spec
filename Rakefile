# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fix_spec"
  gem.homepage = "http://github.com/connamara/fix_spec"
  gem.license = "Connamara"
  gem.summary = %Q{Build and Inspect FIX Messages}
  gem.description = %Q{Build and Inspect FIX Messages with spec and cucumber steps}
  gem.email = "support@connamara.com"
  gem.authors = ["Chris Busbey"]
  # dependencies defined in Gemfile
end

require "rspec/core"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--color --format pretty --format junit --out features/reports}
end
