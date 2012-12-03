Feature: Equivalence

Background:
Given the following fix message: 
"""
8=FIX.4.235=849=ITG56=SILO205=4
"""
And I get the fix message

Scenario: Identical Fix as JSON
Then the FIX message should be:
"""
{
  "8":"FIX.4.2",
  "9":"26",
  "35":"8",
  "49":"ITG",
  "56":"SILO",
  "205":"4",
  "10":"084"
}
"""

Scenario: Identical Fix as raw FIX
Then the FIX message should be:
"""
8=FIX.4.29=2635=849=ITG56=SILO205=410=084
"""

#check sum and msg length are optional when using raw fix
Then the FIX message should be:
"""
8=FIX.4.235=849=ITG56=SILO205=4
"""


Scenario: String
Then the FIX at "49" should be "ITG"

And the fix message at tag "49" should be:
"""
"ITG"
"""
And the FIX at "49" should not be "blah"

#everything is a string w/o a data dictionary
And the FIX at tag "205" should be "4"

Scenario: Table format
Then the fix should have the following:
| 35  | "8"       |
| 8   | "FIX.4.2" |
