@with_data_dictionary
Feature: Building Fix Messages

@ignore_length_and_checksum
Scenario: Building via raw fix (prior to FIXT/FIX50)
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


@ignore_length_and_checksum @fix50
Scenario: Building via raw fix (using FIXT/FIX50)
Given the following unvalidated fix message:
"""
8=FIXT.1.135=81128=849=ITG56=SILO541=20130426315=86=100.25410=50.25424=23.45411=Y43=N40=15=N
"""
When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"ExecutionReport",
  "ApplVerID":"FIX50SP1",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDate":"20130426",
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false,
  "AdvTransType": "NEW",
  "UnderlyingPutOrCall": 8,
  "WtAverageLiquidity":"50.25"
}
"""


Scenario: Building from scratch (prior to FIXT/FIX50)

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

@fix50
Scenario: Building from scratch (using FIXT/FIX50)

Given I create a fix message
And I set the FIX message at "BeginString" to "FIXT.1.1" 
And I set the FIX message at "MsgType" to "ExecutionReport"
And I set the FIX message at "ApplVerID" to "FIX50SP1"
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "MaturityDate" to "20110635"
And I set the FIX message at "DayOrderQty" to 23.45
And I set the FIX message at "ExchangeForPhysical" to true
And I set the FIX message at "AvgPx" to 100.25
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "PossDupFlag" to false

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"ExecutionReport",
  "ApplVerID":"FIX50SP1",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDate":"20110635",
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""

Scenario: Building a message of some type (prior to FIXT/FIX50)
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

@fix50
Scenario: Building a message of some type (using to FIXT/FIX50)
Given I create a fix message of type "ExecutionReport"
And I set the FIX message at "BeginString" to "FIXT.1.1" 
And I set the FIX message at "ApplVerID" to "FIX50SP1" 
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "MaturityDate" to "19590522"
And I set the FIX message at "DayOrderQty" to 23.45
And I set the FIX message at "ExchangeForPhysical" to true
And I set the FIX message at "AvgPx" to 100.25
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "PossDupFlag" to false

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"ExecutionReport",
  "ApplVerID":"FIX50SP1",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDate":"19590522",
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""

Scenario: Building a message of some type and version (prior to FIXT/FIX50)

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

@fix50
Scenario: Building a message of some type and version (using to FIXT/FIX50)

Given I create a FIXT.1.1 message of type "ExecutionReport" 
And I set the FIX message at "ApplVerID" to "FIX50SP1"
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "MaturityDate" to "20150415"
And I set the FIX message at "DayOrderQty" to 23.45
And I set the FIX message at "ExchangeForPhysical" to true
And I set the FIX message at "AvgPx" to 100.25
And I set the FIX message at "OrdType" to "MARKET"
And I set the FIX message at "PossDupFlag" to false

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"ExecutionReport",
  "ApplVerID":"FIX50SP1",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDate":"20150415",
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""


Scenario: Setting message fields via table (prior to FIXT/FIX50)
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

@fix50
Scenario: Setting message fields via table (prior to FIXT/FIX50)
Given I create the following FIXT.1.1 message of type "ExecutionReport": 
|ApplVerID            | "FIX50SP1" |
|SenderCompID         | "ITG"      |
|TargetCompID         | "SILO"     |
|MaturityDate         | "20150415" |
|DayOrderQty          | 23.45      |
|ExchangeForPhysical  | true       |
|AvgPx                | 100.25     |
|OrdType              | "MARKET"   |
|PossDupFlag          | false      |

When I get the fix message
Then the fix message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"ExecutionReport",
  "ApplVerID":"FIX50SP1",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "MaturityDate":"20150415",
  "DayOrderQty": 23.45,
  "ExchangeForPhysical": true,
  "AvgPx": 100.25,
  "OrdType": "MARKET",
  "PossDupFlag": false
}
"""

