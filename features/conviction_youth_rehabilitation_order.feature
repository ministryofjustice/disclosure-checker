Feature: Conviction
  Scenario Outline: Community or youth rehabilitation order (YRO)
  Given I am completing a basic under 18 "Community or youth rehabilitation order (YRO)" conviction
  Then I should see "What was your community order?"
  And I choose <subtype>

  When I enter a valid date
  Then I should see "Was the length of conviction given in weeks, months or years?"
  And  I choose "Weeks"
  Then I should see "What was the length of the order?"
  And I fill in "What was the length of the order?" with "10"
  Then I click the "Continue" button
  Then I should be on <result>

  Examples:
    | subtype                                                          | result                 |
    | "Alcohol abstinence or treatment"                                | "/steps/check/results" |
    | "Attendance centre order"                                        | "/steps/check/results" |
    | "Behavioural change programme"                                   | "/steps/check/results" |
    | "Curfew"                                                         | "/steps/check/results" |
    | "Drug rehabilitation, treatment or testing"                      | "/steps/check/results" |
    | "Exclusion requirement"                                          | "/steps/check/results" |
    | "Intoxicating substance treatment requirement"                   | "/steps/check/results" |
    | "Mental health treatment"                                        | "/steps/check/results" |
    | "Prohibition"                                                    | "/steps/check/results" |
    | "Referral order"                                                 | "/steps/check/results" |
    | "Rehabilitation activity requirement (RAR)"                      | "/steps/check/results" |
    | "Reparation order"                                               | "/steps/check/results" |
    | "Residence requirement"                                          | "/steps/check/results" |
    | "Sexual harm prevention order (sexual offence prevention order)" | "/steps/check/results" |
    | "Supervision order on breach of a civil injunction"              | "/steps/check/results" |
    | "Unpaid work"                                                    | "/steps/check/results" |
