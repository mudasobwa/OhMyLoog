# encoding: utf-8

Given "there is an instance of Loogger for terminal output" do
  @loog = OhMyLoog::Loogger.new(STDOUT)
  @tty = OhMyLoog::Writers::XTerm256.instance
end

When "I issue the logger backend" do
  @backend = @loog.backend
end

Then "it’s class is XTerm256" do
  @tty === @backend
end

When /^I call loogger’s info method on "(.*?)" string/ do |msg|
  @s = msg
  @c = @tty.format msg, Logger::INFO
end

Then "text on blue background without any additional styling should appear" do
  bg = OhMyLoog::Writers::Color.xterm256(:info)
  raise "Escaped string (#{@c.dump}) is wrong" unless @c =~ /\[38;05;(\d+);48;05;#{bg}m(.*?)\n#{@s}/m
end

When /^I call loogger’s warn method on "(.*?)" string/ do |msg|
  @s = msg
  @c = @tty.format msg, Logger::WARN
end

Then "text on orange background without any additional styling should appear" do
  bg = OhMyLoog::Writers::Color.xterm256(:warning)
  raise "Escaped string (#{@c.dump}) is wrong" unless @c =~ /\[38;05;(\d+);48;05;#{bg}m(.*?)\n#{@s}/m
end

When /^I call loogger’s error method on "(.*?)" string/ do |msg|
  @s = msg
  @c = @tty.format msg, Logger::ERROR
end

Then "bold text on red background without any additional styling should appear" do
  bg = OhMyLoog::Writers::Color.xterm256(:error)
  raise "Escaped string (#{@c.dump}) is wrong" unless @c =~ /\[01;38;05;(\d+);48;05;#{bg}m(.*?)\n#{@s}/m
end

