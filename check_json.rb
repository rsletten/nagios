require 'net/http'
require 'rubygems'
require 'json'

# variables
@host = '10.40.14.41'
@port = '8088'
@post = '/camstar-falcon-analysis/rest/search/event'
@payload = File.read('dellrequest.txt') 


def post
  req = Net::HTTP::Post.new(@post, initheader = {'Content-Type' =>'application/json'})
    req.body = @payload
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    puts response.body
end

parsed = JSON.parse(post)

timedOut =  parsed.fetch("requestList")[0]["request"]["inclusionFilters"][1]["fieldName"]
hasError =  parsed.fetch("requestList")[0]["request"]["inclusionFilters"][1]["fieldName"]

if timedOut.to_s == 'false'
  puts 'Check Passed'
  exit 0
elsif hasError.to_s == 'false'
  puts 'Check Passed'
  exit 0
else
  puts 'Check Failed'
  exit 1
