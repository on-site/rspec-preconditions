[![Gem Version](https://badge.fury.io/rb/rspec-preconditions.svg)](https://badge.fury.io/rb/rspec-preconditions)
[![Build Status](https://secure.travis-ci.org/on-site/rspec-preconditions.svg?branch=master)](http://travis-ci.org/on-site/rspec-preconditions)

# RSpec::Preconditions

Sometimes every example in an RSpec example group fails because of a bug in the before hook.

Wouldn't you rather see the error only once, rather than for every single example?

Now you can!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-preconditions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-preconditions

## Usage

We've all written tests like this:

```
RSpec.describe Array do
  subject { [1, 'A', nil] }

  before(:each) do
    subject.sort!
  end

  it 'still contains 1 after sorting' do
    expect(subject).to include(1)
  end

  it 'still contains "A" after sorting' do
    expect(subject).to include('A')
  end

  it 'still contains nil after sorting' do
    expect(subject).to include(nil)
  end
end
```

And as long as the setup code doesn't raise any Exceptions, it works great!

The problem is, sometimes the setup code does raise Exceptions--and not just one Exception, but the same Exception for every example in the group!

Wouldn't it be nice if you could see just one failed test at the end?  After all, there's only one bug that you need to diagnose.

Now you can, with just one change:

```
before(:each) do
  subject.sort!
end
```

becomes:

```
preconditions do
  subject.sort!
end
```

Now, if it fails, then you only see one failed test.  The rest of the test that show an identical failure are listed as pending.

Nice!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/on-site/rspec-preconditions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
