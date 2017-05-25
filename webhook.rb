# frozen_string_literal: true

require "bundler/setup"
require "sinatra/base"
require "json"
require "octokit"
require "slack-ruby-client"

Slack.configure do |config|
  config.token = ENV["SLACK_API_TOKEN"]
  raise("Missing ENV[SLACK_API_TOKEN]") unless config.token
end

module GHStatusWebhook
  class Webhook < Sinatra::Base
    post "/payload" do
      json = JSON.parse(request.body.read)
      return unless json["state"]

      repository = json["name"]
      sha = json["sha"]

      puts "Repository: #{repository}"
      puts "SHA: #{sha}"
      puts "State: #{json['state']}"

      gh_client = Octokit::Client.new(netrc: true)
      pull_requests = gh_client.pull_requests(repository, state: "open")
      pull_request = pull_requests.find { |pr| pr.head.sha == sha }
      return if pull_request.nil?

      pull_request_url = pull_request.html_url
      pull_request_user = pull_request.user.login
      puts "Pull request user: #{pull_request_user}"

      pull_request_statuses = gh_client.statuses(repository, pull_request.head.sha).group_by(&:context)
      # We're only interested in the latest status per context
      pull_request_statuses.transform_values! { |statuses| statuses.first.state }

      if pull_request_statuses.values.none? { |state| state == "pending" }
        slack_client = Slack::Web::Client.new
        message = "All tests are done: #{pull_request_url}"
        slack_client.chat_postMessage(channel: "@julian", text: message, as_user: true)
      else
        puts "Some statuses are still pending"
      end
    end
  end
end
