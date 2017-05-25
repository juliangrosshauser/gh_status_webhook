# frozen_string_literal: true

require "bundler/setup"
require "octokit"
require "pp"

REPOSITORY = "juliangrosshauser/gh_status_webhook"

client = Octokit::Client.new(netrc: true)
pull_requests = client.pull_requests(REPOSITORY, state: "open")
pull_requests.map(&:to_h).each { |pr| pp pr }
