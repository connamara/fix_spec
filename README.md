fix_spec
========

Build and Inspect FIX Messages


Cucumber
--------

fix_spec provides Cucumber steps that utilize its RSpec matchers.

In order to us ethe Cucumber steps, in your `env.rb` you must:

```ruby
require "fix_spec/cucumber"
```

You also need to define a `last_fix` method that will be called by fix_spec to grab the FIX message to test.

### tests

    bundle exec spec

### cucumber

    env JAVA_OPTS=-XX:MaxPermSize=2048m bundle exec rake cucumber
