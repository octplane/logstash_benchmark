logstash_benchmark
==================

Simple Logstash Benchmarking for testing purposes. This is a benchmark that was setup to test redis speed input and diagnose an issue in the Time Parsing facility of Logtash.
The Time Parsing speed improvements are integrated in logstash since: https://github.com/logstash/logstash/pull/894/files

Also, some variables to tweak on the redis input and the Elasticsearch output.

- `batch_count`: should contain a large enough value to speed up redis reading
- in the ES output, `flush_size` controls the size of the bulk insert.

Protocol
========

- start a localhost redis
- run ruby benchmark.rb
- run java -jar logstash-1.2.2-flatjar.jar agent -f null.conf
- See result in benchmark.rb output
- Create a meaningful folder with information about your JVM and system specs and the benchmark results
- PR to update and add you results

Contributors
============

- Pierre Baillet (@octplane), original author
- Carlos (nzlosh on Github), port of script to Python
