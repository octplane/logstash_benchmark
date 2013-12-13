logstash_benchmark
==================

Simple Logstash Benchmarking for testing purposes


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
