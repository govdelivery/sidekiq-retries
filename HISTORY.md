# Changelog

## 0.5.0
* Add support for sidekiq >= 5

## 0.4.0

## 0.3.0
* stop cutting + pasting Sidekiq retry logic, which is now extracted into a method (https://github.com/mperham/sidekiq/pull/1928)
* require sidekiq 3.2.4

## 0.2.0
* simplify retry/fail logic
* fix retry: 0, which was going straight to the dead queue

## 0.1.0

* sidekiq 3 compatibility

## 0.0.1

* initial release for sidekiq 2.17.x

