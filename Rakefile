require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
  t.verbose = true
end

namespace :test do
  desc "Purge VCR cassettes"
  task :purge_vcr do
    FileUtils.rm_rf("test/fixtures/vcr_cassettes")
  end
end
