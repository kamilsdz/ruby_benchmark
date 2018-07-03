# RubyBenchmark

Based on Ruby Performance Optimization - Alexander Dymo

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_benchmark', git: 'https://github.com/kamilsdz/ruby_benchmark.git'
```

And then execute:

    $ bundle

## Usage

Wrap your code:

```ruby
RubyBenchmark.run { block }
```
or
```ruby
RubyBenchmark.run do
  block  
end
```

Available methods: 

- run - for basic info
- generate_flat(1)  # parameter is optional - it's minimal %self, default 1
- generate_graph(1) # parameter is optional
- generate_call_stack
- generate_call_tree - recommended QCachegrind, install: brew install qcachegrind

'generate' methods create tmp/profile directory for reports.

### Rails

Insert ruby-prof adapter into the middleware stack:
```ruby
config.middleware.use Rack::RubyProf, path: '/tmp/profile'
```
or if you want profile middleware:
```ruby
config.middleware.insert_before Rack::Runtime, Rack::RubyProf, path: '/tmp/profile'
```
