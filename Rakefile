# frozen_string_literal: true

require "bundler/setup"
require "rake"
require "rubocop/rake_task"

RuboCop::RakeTask.new do |t|
  t.options << "--display-cop-names"
end

task default: %w[rubocop]
