fix\_spec [![Build Status](https://travis-ci.org/connamara/fix_spec.png)](https://travis-ci.org/connamara/fix_spec)
=========

RSpec matchers and Cucumber step definitions for testing FIX Messages using [json_spec](https://github.com/collectiveidea/json_spec) and [quickfix-jruby](https://github.com/connamara/quickfix-jruby)

Usage
-----

### RSpec

fix\_spec currently defines two matchers:

* ```be_fix_eql```
* ```have_fix_path```

The matchers can be used as their counterparts are used in json\_spec

### Cucumber

fix_spec provides Cucumber steps that utilize its RSpec matchers.

In order to us ethe Cucumber steps, in your `env.rb` you must:

```ruby
require "fix_spec/cucumber"
```

#### "Should" Assertions

In order to test the contents of a FIX message, you will need to define a `last_fix` method.  This method will be called by fix_spec to grab the FIX message to test. For example, suppose a step aquires a fix message and assigns it to `@my_fix_message`.  In your `env.rb` you could then have

```ruby
def last_fix
  @my_fix_message
end
```

See [features/support/env.rb](features/support/env.rb) and [features/step_definitions/steps.rb](features/step_definitions/steps.rb) for a very simple implementation.

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


#### Building FIX Messages

In order to use the Cucumber steps for building FIX messages, in your `env.rb` you must:

```ruby
require "fix_spec/builder"
```
Now you can use fix_spec builder steps in your features:

```cucumber
Feature: Order Adapter accepts Orders

Scenario: It accepts Market Orders

Given I create a FIX.4.2 message of type "NewOrderSingle" 
And I set the FIX message at "SenderCompID" to "MY_SENDER"
And I set the FIX message at "TargetCompID" to "MY_TARGET"
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "OrderQty" to 123
Then I send the message
```

Or it can be simplified using a table:

```cucumber
Given I create the following FIX.4.2 message of type "NewOrderSingle":
| SenderCompID | "MY_SENDER" |
| TargetCompID | "MY_TARGET" |
| OrdType      | "MARKET"    |
| OrderQty     | 123         |
```

You can even do repeating groups:

```cucumber
Given I create the following FIX.4.2 message of type "NewOrderList":
| ListID      | "List_ID" |
| NoOrders    | 2         |
And I add the following "NoOrders" group:
| Symbol   | "ABC" |
| Side     | "BUY" |
| OrderQty | 123   |
And I add the following "NoOrders" group:
| Symbol   | "ABC"  |
| Side     | "SELL" |
| OrderQty | 123    |
```

The built FIX message can be accessed through the `message` function in the ```FIXSpec::Builder``` module.

### Configuration

#### DataDictionary

FIXSpec works best when a DataDictionary is provided.  With a DataDictionary loaded, you can inspect a message with named tags, enumeration, and type specific tag values.

The DataDictionary is globally set:

```ruby
FIXSpec::data_dictionary = FIXSpec::DataDictionary.new "config/FIX42.xml"
```

#### Exclusion

When checking for fix message equality, you may wish to ignore some common fields that are mostly session level.  For example, at an application level, BodyLength and CheckSum can be assumed to be set correctly. Tag exclusion is configured globally via JsonSpec:

```ruby
JsonSpec.configure do
  exclude_keys "BodyLength", "CheckSum", "MsgSeqNum"
end
```

### More

Check out [specs](spec/) and [features](features/) to see all the ways you can use fix_spec.

Install
-------

```shell
gem install fix_spec
```

or add the following to Gemfile:
```ruby
gem 'fix_spec'
```
and run `bundle install` from your shell.

More Information
----------------

* [Rubygems](https://rubygems.org/gems/fix_spec)
* [Issues](https://github.com/connamara/fix_spec/issues)
* [Connamara Systems](http://connamara.com)

Contributing
------------

Please see the [contribution guidelines](CONTRIBUTION_GUIDELINES.md).

Credits
-------

Contributers:

* Chris Busbey
* Matt Lane
* Ben Gura
* Brad Haan

![Connamara Systems](http://www.connamara.com/images/home-connamara-logo-lg.png)

fix_spec is maintained and funded by [Connamara Systems, llc](http://connamara.com).

The names and logos for Connamara Systems are trademarks of Connamara Systems, llc.

Licensing
---------

fix_spec is Copyright © 2013 Connamara Systems, llc. 

This software is available under the GPL and a commercial license.  Please see the [LICENSE](LICENSE.txt) file for the terms specified by the GPL license.  The commercial license offers more flexible licensing terms compared to the GPL, and includes support services.  [Contact us](mailto:info@connamara.com) for more information on the Connamara commercial license, what it enables, and how you can start commercial development with it.

This product includes software developed by quickfixengine.org ([http://www.quickfixengine.org/](http://www.quickfixengine.org/)). Please see the [QuickFIX Software LICENSE](QUICKFIX_LICENSE.txt) for the terms specified by the QuickFIX Software License.
