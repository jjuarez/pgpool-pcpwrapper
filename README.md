# PGPool::Wrapper

This is a little gem to help with the PGPool PCP administration interface

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pgpool-pcpwrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pgpool-pcpwrapper

## Usage

So simple, instantiate a PGPoll::PCPWrapper and send the appropiate commands through the PCP interface. 

### How many backend nodes handle this instance of PGPool?

    'require 'pgpool/pcpwrapper'
    
    pcp = PGPool::PCPWrapper.new(
            hostname: 'localhost',
            port:     9898,
            user:     'pgpool_user',
            password: 'supersecret',
            timeout:  5
    
    puts pcp.number_of_nodes


### How about the status of node 0

    pcp = PGPool::PCPWrapper.new(
            hostname: 'localhost',
            port:     9898,
            user:     'pgpool_user',
            password: 'supersecret',
            timeout:  5

    puts pcp.node_information(0)


### Ey!, giveme the status of all backend nodes

    pcp = PGPool::PCPWrapper.new(
            hostname: 'localhost',
            port:     9898,
            user:     'pgpool_user',
            password: 'supersecret',
            timeout:  5
    puts pcp.nodes_information(0)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jjuarez/pgpool-pcpwrapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

