#!/usr/bin/env ruby

require 'net/http'
require 'rubygems'
require 'json'

# variables
@host = '10.40.20.15'
@port = '8080'
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

timedOut =  parsed.fetch("timedOut")
hasError =  parsed.fetch("hasError")

<<<<<<< HEAD

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
=======
if timedOut.to_s == 'false' && hasError.to_s == 'false'
  return STATE_OK
else
  return STATE_CRITICAL
end

>>>>>>> 8b2e5d81abe7d2d85e1ce1f5b395687ef6e66c87
