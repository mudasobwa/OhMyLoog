# encoding: utf-8

@colorization
Feature: Colorizing output with terminal escape sequences
  In order to enjoy the logging abilities of an application
  Developers should be able to print out colorized messages to terminal

  @important
  Scenario: Print colorized string to stdout
    Given there is an instance of Loogger for terminal output
    When I call loogger’s pattern method with fg color ("#ff6600",) bg color ("#333",) and set of modifiers ("{:b=>true, :u=>true, :i=>true, :r=>true}")
    Then escaped string for two colors and all the modifiers is to be returned
     But no other formatting is being applied
