
require "rubygems"
require "bundler/setup"

require "redis"

REDIS_HOST = ENV["REDIS_HOST"] || "localhost"
REDIS_PORT = (ENV["REDIS_PORT"] || "6379").to_i
REDIS_QUEUE = ENV["REDIS_QUEUE"] || "test"
COUNT = 100000

redis = Redis.new(host: REDIS_HOST, port: REDIS_PORT)
puts "Flushing redis"

while(redis.llen(REDIS_QUEUE) > 0) do
  redis.lpop(REDIS_QUEUE)
end
puts "done."

sample_line = "{\"@timestamp\":\"2013-12-10T16:40:02.880+00:00\",\"@version\":\"1\",\"@tags\":[],\"@fields\":{\"instance\":\"devobox\",\"facility\":\"service-front\",\"method\":\"POST\",\"path\":\"/event/1.0/impression/afe\",\"http_host\":\"fr.fotopedia.com\",\"user_agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36\",\"operation_id\":\"7f00000152a743e2380d075903043402\",\"ssl\":\"false\",\"remote_addr\":\"127.0.0.1\",\"nginx_cookie\":\"fwAAAVHMVqNadNwdxAwMMAg==\",\"status\":\"200\",\"elapsed\":0.003,\"endpoint\":\"/_tevent/**\"}}"

1.upto(COUNT) do |i|
  redis.rpush(REDIS_QUEUE, sample_line)
end

puts "Pushed #{COUNT} lines in redis. Waiting for logstash to start up"
puts "Waiting for exhaustion"

status = 0
start_time = nil
end_time = nil
while(true) do
  c = redis.llen(REDIS_QUEUE)
  if c != COUNT && start_time == nil
    start_time = Time.now
  end
  if c == 0
    end_time = Time.now
    break
  end
  sleep(0.05)
end

puts "Completed, estimated speed: #{(COUNT/(end_time - start_time)).to_i} event/s processed"