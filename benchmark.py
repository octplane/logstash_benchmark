#!/usr/bin/env python
from os import getenv
from redis import Redis
from time import sleep, time

REDIS_HOST = getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(getenv("REDIS_PORT", "6379"))
REDIS_QUEUE = getenv("REDIS_QUEUE", "test")
COUNT = 100000

redis = Redis(host=REDIS_HOST, port=REDIS_PORT)
print("Flushing redis")

while(redis.llen(REDIS_QUEUE) > 0):
  redis.lpop(REDIS_QUEUE)

print("done.")

sample_line = "{\"@timestamp\":\"2013-12-10T16:40:02.880+00:00\",\"@version\":\"1\",\"@tags\":[],\"@fields\":{\"instance\":\"devobox\",\"facility\":\"service-front\",\"method\":\"POST\",\"path\":\"/event/1.0/impression/afe\",\"http_host\":\"fr.fotopedia.com\",\"user_agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36\",\"operation_id\":\"7f00000152a743e2380d075903043402\",\"ssl\":\"false\",\"remote_addr\":\"127.0.0.1\",\"nginx_cookie\":\"fwAAAVHMVqNadNwdxAwMMAg==\",\"status\":\"200\",\"elapsed\":0.003,\"endpoint\":\"/_tevent/**\"}}"


for i in xrange(COUNT):
  redis.rpush(REDIS_QUEUE, sample_line)


print("Pushed %d lines in redis. Waiting for logstash to start up" % COUNT )
print("Waiting for exhaustion")

status = 0
start_time = None
end_time = None
while(True):
  c = redis.llen(REDIS_QUEUE)
  if c != COUNT and start_time == None:
    start_time = time()
  if c == 0:
    end_time = time()
    break


print( "Completed, estimated speed: %d event/s processed" % int((COUNT/(end_time - start_time))) )
