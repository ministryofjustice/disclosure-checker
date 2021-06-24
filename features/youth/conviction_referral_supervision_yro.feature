Feature: Conviction
  Scenario Outline: Referral or youth rehabilitation order (YRO)
  Given I am completing a basic under 18 "Referral or youth rehabilitation order (YRO)" conviction
  Then I should see "What was your referral or youth rehabilitation order (YRO)?"

  When I choose "<subtype>"
  Then I should see "<known_date_header>"

  And I enter a valid date
  Then I should see "<length_type_header>"

  And  I choose "Weeks"
  Then I should see "<length_header>"
  And I fill in "Number of weeks" with "10"

  Then I click the "Continue" button
  And I check my "conviction" answers and go to the results page

  Examples:
    | subtype                    | known_date_header                              | length_type_header                                           | length_header                     |
    | Referral order             | What was the date of your first panel meeting? | Was the length of the order given in days, weeks, months or years? | What was the length of the order? |
    | Supervision order          | When were you given the order?                 | Was the length of the order given in days, weeks, months or years? | What was the length of the order? |
    | Youth rehabilitation order | When were you given the order?                 | Was the length of the order given in days, weeks, months or years? | What was the length of the order? |
