# RubyBenchmark

Based on Ruby Performance Optimization - Alexander Dymo

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_benchmark', git: 'https://github.com/kamilsdz/ruby-benchmark.git'
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

- run for basic info
- generate flat(min = 1) # min is optional
- generate_graph(min = 1) # min is optional
- generate_call_stack
- generate_call_tree - recommended QCachegrind, install: brew install qcachegrind


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_benchmark. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyBenchmark project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruby_benchmark/blob/master/CODE_OF_CONDUCT.md).
