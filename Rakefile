# frozen_string_literal: true

require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'inch/rake'
Inch::Rake::Suggest.new(:inch)

require 'rake/testtask'
Rake::TestTask.new(:test) do |task|
  task.libs << 'lib'
  task.libs << 'test'
  task.test_files = FileList['test/**/*_test.rb']
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new(:yard)

require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
  measurement.output = 'coverage/docs.txt'
end

require 'yardstick/rake/verify'
Yardstick::Rake::Verify.new(:yardstick_verify) do |verify|
  verify.threshold = 100
end

task yardstick: %i[yardstick_measure yardstick_verify]

task default: %i[test rubocop yard inch]
