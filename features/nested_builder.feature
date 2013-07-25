@with_data_dictionary
Feature: Building Fix Messages with repeating groups from raw fix

@ignore_length_and_checksum
Scenario: Building fix message with 2 instances in a nested group
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
