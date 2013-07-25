@with_data_dictionary @ignore_length_and_checksum
Feature: Memory

Background:

Given the following fix message: 
"""
8=FIX.4.235=849=ITG56=SILO44=1250.25
"""

When I get the fix message

Scenario: Entire FIX message
  When I keep the FIX message as "FIX1"
  Then the FIX message should be %{FIX1}
  And the FIX message should be:
    """
    %{FIX1}
    """
    
Scenario: String header field
  When I keep the FIX message at tag "MsgType" as "MSGTYPE"
  Then the FIX message at "MsgType" should be %{MSGTYPE}
  And the FIX message should be:
  """
  {
    "MsgType": %{MSGTYPE},
    "SenderCompID": "ITG",
    "TargetCompID": "SILO",
    "BeginString": "FIX.4.2",
    "Price": 1250.25
  }
  """
  
Scenario: Numerical body field
  When I keep the FIX message at tag "Price" as "PRICE"
  Then the FIX message at "Price" should be %{PRICE}
  And the FIX message should be:
  """
  {
    "MsgType": "ExecutionReport",
    "SenderCompID": "ITG",
    "TargetCompID": "SILO",
    "BeginString": "FIX.4.2",
    "Price": %{PRICE}
  }
  """