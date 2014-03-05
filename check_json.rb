#!/usr/bin/env ruby

require 'net/http'
require 'rubygems'
require 'json'

# variables
@host = ARGV[0] 
@port = ARGV[1]
@post = '/camstar-falcon-analysis/rest/search/event'

if ARGV[2] == 'dell'
   @payload = File.read('/nagios/libexec/dellrequest.txt')
elsif ARGV[2] == 'camstar' 
   @payload = File.read('/nagios/libexec/camstarrequest.txt')
else
  puts "specify which tenant"
  exit 3
end

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
rescue Exception => e
  puts "Can't connect to " + @host.to_s + ":" + @port.to_s + ". Perhaps jetty is down?"
  exit 2
end

parsed = JSON.parse(post)

timedOut = parsed.fetch("timedOut")
hasError = parsed.fetch("hasError")

if timedOut.to_s == 'true'
  puts 'timedOut is true'
  exit 2
elsif hasError.to_s == 'true'
  puts 'hasError is true'
  exit 1 
else
  puts 'Check Passed'
  exit 0
end
