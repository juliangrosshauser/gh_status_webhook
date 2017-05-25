# frozen_string_literal: true

require "bundler/setup"
require "sinatra/base"
require "json"

module GHStatusWebhook
  class Webhook < Sinatra::Base
    post "/payload" do
      json = JSON.parse(request.body.read)
      return unless json["state"]
      puts "State: #{json['state']}"
    end
  end
end
