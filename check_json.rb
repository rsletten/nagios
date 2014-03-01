#!/usr/bin/env ruby

require 'net/http'
require 'rubygems'
require 'json'

# variables
@host = ARGV[0] 
@port = ARGV[1]
@post = '/camstar-falcon-analysis/rest/search/event'
@payload = File.read('dellrequest.txt') 
# Nagios Exit codes
STATE_OK = '0'
STATE_WARNING = '1'
STATE_CRITICAL = '2'
STATE_UNKNOWN = '3'


def post
  req = Net::HTTP::Post.new(@post, initheader = {'Content-Type' =>'application/json'})
    req.body = @payload
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    return response.body
end

parsed = JSON.parse(post)

timedOut = parsed.fetch("timedOut")
hasError = parsed.fetch("hasError")


if timedOut.to_s == 'true'
  puts 'timedOut is true'
  exit STATE_CRITICAL
elsif hasError.to_s == 'true'
  puts 'hasError is true'
  exit STATE_WARNING
else
  puts 'Check Passed'
  exit STATE_OK
end
