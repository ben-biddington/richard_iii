require "bundler/gem_tasks"

require 'rake/testtask'

namespace :test do 
  Rake::TestTask.new do |t|
    t.name = 'unit'		   
    t.test_files = FileList['test/unit.tests/**/*.rb']
  end

  Rake::TestTask.new do |t|
    t.name = 'acceptance'		   
    t.test_files = FileList['test/acceptance.tests/**/*.rb']
  end
end

task :default => "test:unit"
