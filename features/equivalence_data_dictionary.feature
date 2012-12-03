@with_data_dictionary
Feature: Equivalence with data dictionary

When configured with a data dictionary,  cucumber steps can accept richer, type specific fix parameters and values

Background:
Given the following fix message: 
"""
8=FIX.4.235=849=ITG56=SILO205=4315=86=100.25410=50.25424=23.45411=Y43=N40=15=N
"""
When I get the fix message


Scenario: All these checks are acceptable
Then the FIX at "SenderCompID" should be "ITG"
Then the fix at tag "SenderCompID" should be "ITG"
Then the fix message at "SenderCompID" should be "ITG"
And the FIX at "SenderCompID" should not be "blah"
And the fix message at tag "SenderCompID" should be:
"""
"ITG"
"""

And the fix message at tag "SenderCompID" should not be:
"""
"NOT ITG"
"""

Scenario Outline: Types values are type specific
Then the FIX at tag "<TAG>" should be <VALUE>

Examples: Enumerations
| TAG                 | VALUE             |
| OrdType             | "MARKET"          | 
| AdvTransType        | "NEW"             | 

Examples: MsgType -doesn't map to DD description
| MsgType             | "ExecutionReport"|

Examples: STRING
| TAG                 | VALUE |
| SenderCompID  | "ITG" |

Examples: INT
| TAG                 | VALUE |
|UnderlyingPutOrCall  | 8     |

Examples: DAYOFMONTH
| TAG         | VALUE |
|MaturityDay  | 4     |

Examples: FLOAT and derivative types can accept many different formats
| TAG         | VALUE |
| AvgPx       | 100.25|
| AvgPx      | 100.25000|
| AvgPx      | 100.25e0|
| AvgPx      | 100.25e+0|
| AvgPx      | 100.25e-0|
| AvgPx      | 1.0025e+2|

Examples: PRICE
| TAG         | VALUE      |
|AvgPx        | 100.25     |

Examples: FLOAT
| TAG                      | VALUE      |
|WtAverageLiquidity        | 50.25      |

Examples: QTY
| TAG                      | VALUE      |
|DayOrderQty               | 23.45      |

Examples: BOOLEAN
| TAG                      | VALUE      |
|PossDupFlag               | false      |
|ExchangeForPhysical       | true       |


Scenario: Table Format
Then the fix should have the following:
| SenderCompID          | "ITG"     |
| BeginString           | "FIX.4.2" |
| MaturityDay           | 4         |
| UnderlyingPutOrCall   | 8         |
| AvgPx                 | 100.25    |
