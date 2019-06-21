Feature: Conviction
  Scenario Outline: YRO
  Given I am completing a basic under 18 <conviction> conviction
  When I am completing YRO with <subtype>
  Then I should be on <result>

  Examples:
    | conviction                                      | subtype                                                          | result                 |
    | "Community or youth rehabilitation order (YRO)" | "Alcohol abstinence or treatment"                                | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Attendance centre order"                                        | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Behavioural change programme"                                   | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Curfew"                                                         | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Drug rehabilitation, treatment or testing"                      | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Exclusion requirement"                                          | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Intoxicating substance treatment requirement"                   | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Mental health treatment"                                        | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Prohibition"                                                    | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Referral order"                                                 | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Rehabilitation activity requirement (RAR)"                      | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Reparation order"                                               | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Residence requirement"                                          | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Sexual harm prevention order (sexual offence prevention order)" | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Supervision order on breach of a civil injunction"              | "/steps/check/results" |
    | "Community or youth rehabilitation order (YRO)" | "Unpaid work"                                                    | "/steps/check/results" |
