@with_data_dictionary
Feature: Matching a Fix Messages with repeating groups

Scenario: Matching a fix message with repeating groups
Given I create the following FIX.4.2 message of type "News":
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And I add the following "LinesOfText" group:
| Text           | "The bears have been cowed by the bulls." |
| EncodedTextLen | 5                                         |
And I add the following "LinesOfText" group:
| Text           | "Buy buy buy" |
| EncodedTextLen | 0             |
When I get the fix message
Then the FIX message should have the following:
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And the FIX message should have the following "LinesOfText" repeating group:
| Text                                      | EncodedTextLen |
| "The bears have been cowed by the bulls." | 5              |
| "Buy buy buy"                             | 0              |

Scenario: Matching inequivalence for a fix message with repeating groups
Given I create the following FIX.4.2 message of type "News":
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And I add the following "LinesOfText" group:
| Text           | "The bears have been cowed by the bulls." |
| EncodedTextLen | 5                                         |
And I add the following "LinesOfText" group:
| Text           | "Buy buy buy" |
| EncodedTextLen | 0             |
When I get the fix message
Then the FIX message should have the following:
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And the FIX message should not have the following "LinesOfText" repeating group:
| Text               | EncodedTextLen |
| "bears and bulls." | 3              |
| "Sell sell sell"   | 2              |

Scenario: Matching fields on a fix message with repeating groups
Given I create the following FIX.4.2 message of type "News":
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And I add the following "LinesOfText" group:
| Text           | "The bears have been cowed by the bulls." |
| EncodedTextLen | 5                                         |
And I add the following "LinesOfText" group:
| Text           | "Buy buy buy" |
| EncodedTextLen | 0             |
When I get the fix message
Then the FIX message should have the following:
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And the FIX message should have the following "LinesOfText" repeating group:
| Text | EncodedTextLen |

Scenario: Checking missing fields on a fix message with repeating groups
Given I create the following FIX.4.2 message of type "News":
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And I add the following "LinesOfText" group:
| Text           | "The bears have been cowed by the bulls." |
| EncodedTextLen | 5                                         |
And I add the following "LinesOfText" group:
| Text           | "Buy buy buy" |
| EncodedTextLen | 0             |
When I get the fix message
Then the FIX message should have the following:
| PossDupFlag  | false                                        |
| SenderCompID | "ITG"                                        |
| TargetCompID | "SILO"                                       |
| Headline     | "Market Bulls Have Short Sellers on the Run" |
And the FIX message should not have the following "LinesOfText" repeating group:
| NotText | UnencodedNotTextLen |
