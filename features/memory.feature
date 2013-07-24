Feature: Memory

Background:

Given the following fix message: 
"""
8=FIX.4.235=849=ITG56=SILO
"""

When I get the fix message

Scenario: Entire FIX message
When I keep the FIX message as "FIX1"
Then the FIX message should be %{FIX1}
And the FIX message should be:
"""
%{FIX1}
"""