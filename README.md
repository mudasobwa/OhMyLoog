# OhMyLoög

OhMyLoög is one more Logger wrapper for Ruby/RoR. It’s name states for “One Hacking/Honestly More/Messing Yielding/Yawning Logger (Oodles Of Garbage)”. Many variants of abbreviation expansion insinuates the improved logging features.

* OhMyLoög automatically logs the ‘sluggish’ method calls with new ‘Logger::SLOW’ state (through ActiveSupport subscriptions);
* OhMyLoög knows whether the log is being written on terminal and colorizes it with terminal escape sequences;
* OhMyLoög gives an ability to suppress all the logging output with exception of ‘Logger::TEMP’ stated messages (useful for real-time log-based debug);
* OhMyLoög goes with .vim syntax highlighting with rich folding and navigation functionality.

## Installation

Add this line to your application's Gemfile:

    gem 'OhMyLoog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install OhMyLoog

## Usage

```ruby
    @loog = OhMyLoog::Loogger.new(STDOUT)
    @loog.info "Welcome to OhMyLoög"
```

## Testing
 
OhMyLoög is BDD’veloped with [Cucumber](http://cuces.info). 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
