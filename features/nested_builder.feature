@with_data_dictionary
Feature: Building Fix Messages with repeating groups from raw fix

@ignore_length_and_checksum
Scenario: Building fix message with 2 instances in a repeated group
Given the following fix message: 
"""
8=FIX.4.235=B49=ITG56=SILO148=Market Bulls Have Short Sellers on the Run33=258=The bears have been cowed by the bulls.58=Buy buy buy354=043=N40=15=N
"""
When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"News",
  "PossDupFlag":false,
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "Headline":"Market Bulls Have Short Sellers on the Run",
  "LinesOfText":[
    {
      "Text":"The bears have been cowed by the bulls."
    },
    {
      "Text":"Buy buy buy",
      "EncodedTextLen":0
    }
  ]
}
"""


@ignore_length_and_checksum
Scenario: Building fix message with repeating groups in repeating groups
Given the following fix message: 
"""
8=FIX.4.235=i49=ITG56=SILO117=ITG_SILO_MASS_QUOTE_001296=1302=Qset001311=JDSU304=1295=1299=Qset001_Q001
"""
When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"MassQuote",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "QuoteID":"ITG_SILO_MASS_QUOTE_001",
  "NoQuoteSets":[
    {
      "QuoteSetID":"Qset001",
      "UnderlyingSymbol":"JDSU",
      "TotQuoteEntries":1,
      "NoQuoteEntries":[
        {
          "QuoteEntryID":"Qset001_Q001"
        }
      ]
    }
  ]
}
"""

@ignore_length_and_checksum
Scenario: Building fix message with repeating group builder
Given I create the following FIX.4.2 message of type "News":
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
| LinesOfText  | 2                                            |
And I add the following "LinesOfText" group:
| Text | "The bears have been cowed by the bulls." |
And I add the following "LinesOfText" group:
| Text           | "Buy buy buy" |
| EncodedTextLen | 0             |
When I get the fix message
Then the FIX message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"News",
  "PossDupFlag":false,
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "Headline":"Market Bulls Have Short Sellers on the Run",
  "LinesOfText":[
    {
      "Text":"The bears have been cowed by the bulls."
    },
    {
      "Text":"Buy buy buy",
      "EncodedTextLen":0
    }
  ]
}
"""