# encoding: utf-8

Given "there is an instance of Loogger for file output" do
  @FILENAME = '/tmp/loogger'
  File.delete(@FILENAME)
  @loog = OhMyLoog::Loogger.new(@FILENAME)
  @tty = OhMyLoog::Writers::File4Vim.instance
end

When "I issue the File4Vim’s logger backend" do
  @backend = @loog.backend
end

Then "it’s class is File4Vim" do
  @tty === @backend
end

When /I call methods debug, info, warn, error, fatal on "(.*?)" string for file/ do |msg|
  @loog.debug msg
  @loog.info msg
  @loog.warn msg
  @loog.error msg
  @loog.fatal msg
end

Then 'they are to be printed to file' do
  File.open(@FILENAME, "r") do |file|
    while line = file.gets
      puts line
    end
  end  
  puts "Please ensure all colors above are OK."
end
