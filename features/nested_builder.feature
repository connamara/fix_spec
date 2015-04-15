@with_data_dictionary
Feature: Building Fix Messages with repeating groups from raw fix

@ignore_length_and_checksum
Scenario: Building fix message with 2 instances in a repeated group (prior to FIXT/FIX50)
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

@ignore_length_and_checksum @fix50
Scenario: Building fix message with 2 instances in a repeated group (using FIXT/FIX50)
Given the following fix message: 
"""
8=FIXT.1.135=B49=ITG56=SILO148=Market Bulls Have Short Sellers on the Run33=258=The bears have been cowed by the bulls.58=Buy buy buy354=043=N40=15=N
"""
When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"News",
  "PossDupFlag":false,
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "Headline":"Market Bulls Have Short Sellers on the Run",
  "NoLinesOfText":[
    {
      "Text":"The bears have been cowed by the bulls."
    },
    {
      "Text":"Buy buy buy",
      "EncodedTextLen":"0"
    }
  ]
}
"""


@ignore_length_and_checksum
Scenario: Building fix message with repeating groups in repeating groups (prior to FIXT/FIX50)
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

@ignore_length_and_checksum @fix50
Scenario: Building fix message with repeating groups in repeating groups (using FIXT/FIX50) 
Given the following fix message: 
"""
8=FIXT.1.135=i49=ITG56=SILO117=ITG_SILO_MASS_QUOTE_001296=1302=Qset001311=JDSU304=1295=1299=Qset001_Q001
"""
When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"MassQuote",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "QuoteID":"ITG_SILO_MASS_QUOTE_001",
  "NoQuoteSets":[
    {
      "QuoteSetID":"Qset001",
      "UnderlyingSymbol":"JDSU",
      "TotNoQuoteEntries":1,
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
Scenario: Building fix message with repeating group builder (prior to FIXT/FIX50)
Given I create the following FIX.4.2 message of type "News":
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
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

@ignore_length_and_checksum @fix50
Scenario: Building fix message with repeating group builder (using FIXT/FIX50)
Given I create the following FIXT.1.1 message of type "News":
| PossDupFlag    | false                         |
| SenderCompID   | "ITG"                         |
| TargetCompID   | "SILO"                        |
| Headline       | "In the frozen land of Nador" |
And I add the following "NoLinesOfText" group:
| Text           | "They were forced to eat Robin's minstrels..." |
And I add the following "NoLinesOfText" group:
| Text           | "and there was much rejoicing." |
| EncodedTextLen | 0                               |
When I get the fix message
Then the FIX message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"News",
  "PossDupFlag":false,
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "Headline":"In the frozen land of Nador",
  "NoLinesOfText":[
    {
      "Text":"They were forced to eat Robin's minstrels..."
    },
    {
      "Text":"and there was much rejoicing.",
      "EncodedTextLen":"0"
    }
  ]
}
"""


@ignore_length_and_checksum
Scenario: Building fix message with multi nested repeating groups (prior to FIXT/FIX50)
Given I create a FIX.4.2 message of type "MassQuote"
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "NoQuoteSets/0/TotQuoteEntries" to "2"
And I set the FIX message at "NoQuoteSets/0/NoQuoteEntries/0/Symbol" to "TSLA"
And I set the FIX message at "NoQuoteSets/0/NoQuoteEntries/1/Symbol" to "IBM"
And I set the FIX message at "NoQuoteSets/1/TotQuoteEntries" to "2"
And I set the FIX message at "NoQuoteSets/1/NoQuoteEntries/0/Symbol" to "GOOG"
And I set the FIX message at "NoQuoteSets/1/NoQuoteEntries/1/Symbol" to "APPL"

When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIX.4.2",
  "MsgType":"MassQuote",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "NoQuoteSets":[
    {
      "TotQuoteEntries":2,
      "NoQuoteEntries":[
        {
        "Symbol":"TSLA"
        },
        {
        "Symbol":"IBM"
        }
      ]
    },
    {
      "TotQuoteEntries":2,
      "NoQuoteEntries":[
        {
        "Symbol":"GOOG"
        },
        {
        "Symbol":"APPL"
        }
      ]
    }
  ]
}
"""


@ignore_length_and_checksum @fix50
Scenario: Building fix message with multi nested repeating groups (using FIXT/FIX50)
Given I create a FIXT.1.1 message of type "MassQuote"
And I set the FIX message at "SenderCompID" to "ITG"
And I set the FIX message at "TargetCompID" to "SILO"
And I set the FIX message at "NoQuoteSets/0/TotNoQuoteEntries" to "2"
And I set the FIX message at "NoQuoteSets/0/NoQuoteEntries/0/Symbol" to "TSLA"
And I set the FIX message at "NoQuoteSets/0/NoQuoteEntries/1/Symbol" to "IBM"
And I set the FIX message at "NoQuoteSets/1/TotNoQuoteEntries" to "2"
And I set the FIX message at "NoQuoteSets/1/NoQuoteEntries/0/Symbol" to "GOOG"
And I set the FIX message at "NoQuoteSets/1/NoQuoteEntries/1/Symbol" to "APPL"

When I get the fix message

Then the FIX message should be:
"""
{
  "BeginString":"FIXT.1.1",
  "MsgType":"MassQuote",
  "SenderCompID":"ITG",
  "TargetCompID":"SILO",
  "NoQuoteSets":[
    {
      "TotNoQuoteEntries":2,
      "NoQuoteEntries":[
        {
        "Symbol":"TSLA"
        },
        {
        "Symbol":"IBM"
        }
      ]
    },
    {
      "TotNoQuoteEntries":2,
      "NoQuoteEntries":[
        {
        "Symbol":"GOOG"
        },
        {
        "Symbol":"APPL"
        }
      ]
    }
  ]
}
"""

