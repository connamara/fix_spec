@with_data_dictionary
Feature: Building Fix Messages

@ignore_length_and_checksum
Scenario: Building via raw fix
Given the following unvalidated fix message: 
"""
8=FIX.4.235=849=ITG56=SILO205=4315=86=100.25410=50.25424=23.45411=Y43=N40=15=N
"""
When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"ExecutionReport",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDay":4,
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false,
  "AdvTransType": "NEW",
  "UnderlyingPutOrCall": 8,
  "WtAverageLiquidity":50.25
}
"""

Scenario: Building from scratch

Given I create a fix message
And I set the FIX message at "BeginString" to "FIX.4.2" 
And I set the FIX message at "MsgType" to "ExecutionReport"
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "MaturityDay" to 4
And I set the FIX message at "DayOrderQty" to 23.45
And I set the FIX message at "ExchangeForPhysical" to true
And I set the FIX message at "AvgPx" to 100.25
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "PossDupFlag" to false

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"ExecutionReport",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDay":4,
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""

Scenario: Building a message of some type
Given I create a fix message of type "ExecutionReport"
And I set the FIX message at "BeginString" to "FIX.4.2" 
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "MaturityDay" to 4
And I set the FIX message at "DayOrderQty" to 23.45
And I set the FIX message at "ExchangeForPhysical" to true
And I set the FIX message at "AvgPx" to 100.25
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "PossDupFlag" to false

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"ExecutionReport",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDay":4,
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""


Scenario: Building a message of some type and version

Given I create a FIX.4.2 message of type "ExecutionReport" 
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "MaturityDay" to 4
And I set the FIX message at "DayOrderQty" to 23.45
And I set the FIX message at "ExchangeForPhysical" to true
And I set the FIX message at "AvgPx" to 100.25
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "PossDupFlag" to false

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"ExecutionReport",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDay":4,
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""


Scenario: Setting message fields via table
Given I create the following FIX.4.2 message of type "ExecutionReport": 
|SenderCompID         | "ITG"     |
|TargetCompID         | "SILO"    |
|MaturityDay          | 4         |
|DayOrderQty          | 23.45     |
|ExchangeForPhysical  | true      |
|AvgPx                | 100.25    |
|OrdType              | "MARKET"  |
|PossDupFlag          | false     |

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"ExecutionReport",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDay":4,
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""
