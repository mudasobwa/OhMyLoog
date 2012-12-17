# encoding: utf-8

@colorization
Feature: Colorizing output with terminal escape sequences
  In order to enjoy the logging abilities of an application
  Developers should be able to print out colorized messages to terminal

  Scenario: Print colorized string to stdout
    Given there is an instance of Loogger for terminal output
    When I issue the XTerm256’s logger backend
    Then it’s class is XTerm256
    When I call loogger’s info method on "Info" string
    Then text on blue background without any additional styling should appear
    When I call loogger’s warn method on "Warn" string
    Then text on orange background without any additional styling should appear
    When I call loogger’s error method on "Error" string
    Then bold text on red background without any additional styling should appear
    When I call methods debug, info, warn, error, fatal on "Terminal Test" string for terminal
    Then they are to be printed on terminal
