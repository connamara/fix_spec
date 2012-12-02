Feature: Paths

Background:

Given the following fix message: 
"""
8=FIX.4.235=849=ITG56=SILO
"""

When I get the fix message

Scenario: BasePaths
Then the fix should have tag "35"
And the fix should not have tag "50"
