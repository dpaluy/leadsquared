# leadsquared gem

This is a simple Ruby wrapper to [Leadsquared](http://apidocs.leadsquared.com/) API

[![Gem Version](https://badge.fury.io/rb/leadsquared.png)](http://badge.fury.io/rb/leadsquared)
[![Build Status](https://secure.travis-ci.org/dpaluy/leadsquared.png)](http://travis-ci.org/dpaluy/leadsquared)
[![Code Climate](https://codeclimate.com/github/dpaluy/leadsquared/badges/gpa.svg)](https://codeclimate.com/github/dpaluy/leadsquared)
[![Test Coverage](https://codeclimate.com/github/dpaluy/leadsquared/badges/coverage.svg)](https://codeclimate.com/github/dpaluy/leadsquared/coverage)
[![Dependency Status](https://gemnasium.com/dpaluy/leadsquared.svg)](https://gemnasium.com/dpaluy/leadsquared)

## Usage

`gem 'leadsquared'`

You just need to provide the authentication details in you configuration, and you're set. For example, in Rails that would go into config/initializers/leadsquared.rb:

```
Leadsquared.configure do |config|
  config.key    = 'mylogin'
  config.secret = 'secret'
  config.logger = Rails.logger
end
```

### NOTE

This version implements only LeadManagement as described [here](http://apidocs.leadsquared.com/meta-data/)

## Contributing to leadsquared

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 David Paluy. See LICENSE.txt for further details.
