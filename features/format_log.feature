# encoding: utf-8

@formatting
Feature: Format output string during logging to file
  In order to enjoy the logging abilities of an application
  Developers should yield the nicely formatted string

  Scenario: Print formatted string to file
    Given there is an instance of Loogger for file output
    When I issue the File4Vim’s logger backend
    Then it’s class is File4Vim
    When I call methods debug, info, warn, error, fatal on "File Test" string for file
    Then they are to be printed to file
