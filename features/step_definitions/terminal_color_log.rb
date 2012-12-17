# encoding: utf-8

require 'OhMyLoog'

Given "there is an instance of Loogger for terminal output" do
  @loog = OhMyLoog::Loogger.new(STDOUT)
end

When /^I call loogger’s pattern method with fg color \("(\S+)",\) bg color \("(\S+)",\) and set of modifiers \("(.*?)"\)$/ do |bg, fg, flags|
  @s = "Test"
  @bg = bg
  @fg = fg
  @flags = {:b => true, :i => true, :u => true, :r => true}
  @c = @loog.pattern @s, @fg, @bg, @flags
end

Then "escaped string for two colors and all the modifiers is to be returned" do
  raise "Escaped string (#{@c.dump}) is wrong" unless @c =~ /\e\[01;03;04;07;38;05;(\d+);48;05;(\d+)m#{@s}\e\[0m/
end

But "no other formatting is being applied" do
  raise "Escaped string (#{@c.dump}) has a garbage" unless @c == "\e[01;03;04;07;38;05;237;48;05;208m#{@s}\e[0m"
end

