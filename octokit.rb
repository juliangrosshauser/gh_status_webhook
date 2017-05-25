# frozen_string_literal: true

require "bundler/setup"
require "octokit"

REPOSITORY = "juliangrosshauser/gh_status_webhook"

client = Octokit::Client.new(netrc: true)
puts client.pull_requests(REPOSITORY, state: "open")
