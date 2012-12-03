Feature: Message Type

Scenario:  the FIX message type should be...
Given the following fix message:
"""
8=FIX.4.435=B49=TR_Initiator52=20090101-17:13:06.68456=TR_Acceptor61=033=158=uno58=dos148=abc
"""
When I get the fix message
Then the FIX message type should be "B"

Scenario:  The FIX message type should not be...
Given the following fix message:
"""
8=FIX.4.435=B49=TR_Initiator52=20090101-17:13:06.68456=TR_Acceptor61=033=158=uno58=dos148=abc
"""
When I get the fix message
Then the FIX message type should not be "A"

@with_data_dictionary
Scenario: With Data Dictionary loaded, message type is pretty string
"""
8=FIX.4.435=B49=TR_Initiator52=20090101-17:13:06.68456=TR_Acceptor61=033=158=uno58=dos148=abc
"""
When I get the fix message
Then the FIX message type should be "News"
