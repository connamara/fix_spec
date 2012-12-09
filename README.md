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

### "Should" Assertions

In order to test the contents of a FIX message, you will need to define a `last_fix` method.  This method will be called by fix_spec to grab the FIX message to test. For example, suppose a step aquires a fix message and assigns it to `@my_fix_message`.  In your `env.rb` you could then have

```ruby
def last_fix
  @my_fix_message
end
```

See `features/support/env.rb` and `features/step_definitions/steps.rb` for a very simple implementation.

Now you can use fix_spec steps in your features:

```cucumber
Feature: New Order

Background:

Given some order message

Scenario: A Market Order is valid


Then the FIX message type should be "NewOrderSingle"
Then the FIX should have tag "OrderQty"
And the FIX message should not have tag "Price"
And the FIX at "SenderCompID" should be "MY_SENDER"

And the FIX messsage should have the following:
|SenderCompID | "MY_SENDER" |
|TargetCompID | "MY_TARGET" |
|OrderQty     | 123         |
|OrdType      | "MARKET"    |

And the FIX message should be:
"""
{
  "BeginString":"FIX.4.2",
  "BodyLength":81,
  "MsgType":"NewOrderSingle",
  "SenderCompID":"MY_SENDER",
  "TargetCompID":"MY_TARGET",
  "OrdType": "MARKET",
  "OrderQty": 123,
  "CheckSum":"083"
}
"""

And the FIX message should be:
"""
8=FIX.4.29-8135=D49=MY_SENDER56=MY_TARGET40=138=12310=083
"""
```

The background step isn't provided by fix_spec.  The remaining steps fix_spec provides. See [features](features/) for more examples.

Setup
-----

    bundle install

Test
----

    bundle exec spec
    env JAVA_OPTS=-XX:MaxPermSize=2048m bundle exec rake cucumber
