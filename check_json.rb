#!/usr/bin/env ruby

require 'net/http'
require 'rubygems'
require 'json'

# variables
@host = '10.40.20.15'
@port = '8080'
@post = '/camstar-falcon-analysis/rest/search/event'
@payload = File.read('dellrequest.txt') 


def post
  req = Net::HTTP::Post.new(@post, initheader = {'Content-Type' =>'application/json'})
    req.body = @payload
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    return response.body
end

parsed = JSON.parse(post)

timedOut =  parsed.fetch("timedOut")
hasError =  parsed.fetch("hasError")


if timedOut.to_s == 'true'
  puts 'timedOut is true'
  exit 1
elsif hasError.to_s == 'true'
  puts 'hasError is true'
  exit 1
else
  puts 'Check Passed'
  exit 0
end
