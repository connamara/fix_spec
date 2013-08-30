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

require "rspec/core/rake_task"
require 'cucumber/rake/task'
RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = %w{--color --format pretty}
end

task :test => [:spec,:cucumber]
task :default => :test

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "fix_spec"
  gem.homepage = "http://github.com/connamara/fix_spec"
  gem.license = "GPL"
  gem.summary = %Q{Build and Inspect FIX Messages}
  gem.description = %Q{Build and Inspect FIX Messages with RSpec and Cucumber steps}
  gem.email = "info@connamara.com"
  gem.authors = ["Chris Busbey"]
  # dependencies defined in Gemfile
end

Jeweler::RubygemsDotOrgTasks.new
