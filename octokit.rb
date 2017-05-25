# frozen_string_literal: true

require "bundler/setup"
require "octokit"
require "pp"

REPOSITORY = "juliangrosshauser/gh_status_webhook"
SHA = "6f40724178ef7de899e197405b3c68b230cc5933"

client = Octokit::Client.new(netrc: true)
pull_requests = client.pull_requests(REPOSITORY, state: "open")
pull_request = pull_requests.find { |pr| pr.head.sha == SHA }
pull_request_status = client.statuses(REPOSITORY, pull_request.head.sha).first
puts pull_request_status.state
