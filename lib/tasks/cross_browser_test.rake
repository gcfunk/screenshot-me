require 'rubygems'
require 'rake/testtask'
require 'parallel'
require 'json'
require_relative '../../app/helpers/cross_browser_helper'

namespace :test do

  @test_folder = "test/cross_browser/*_test.rb"
  @parallel_limit = (ENV["nodes"] || 1).to_i

  task :browserstacklocal do
    sh "BrowserStackLocal #{ENV['BROWSERSTACK_ACCESS_KEY']} localhost,3000,0"
  end

  task :cross_browser, :browsers_file, :local do |t, args|
    ENV['BS_LOCAL'] = args[:local] || true
    browsers_file = args[:browsers_file] || 'test/cross_browser/example_browsers.json'
    @browsers = CrossBrowserHelper.expand_browsers JSON.load(open(browsers_file))
    current_browser = ""
    begin
      ENV['SCREENSHOT_PATH'] = File.join 'tmp', "screenshots_#{Time.new.strftime('%Y_%m_%dT%H_%M_%S')}"
      Parallel.map(@browsers, :in_threads => @parallel_limit) do |browser|
        current_browser = browser
        puts "Running with: #{browser.inspect}"
        CrossBrowserHelper.environment_variables.each_pair do |key, value|
          ENV[value] = browser[key]
        end
        Dir.glob(@test_folder).each do |test_file|
          IO.popen("ruby #{test_file}") do |io|
            io.each do |line|
              puts line
            end
          end
        end
      end
    rescue SystemExit, Interrupt
      puts "User stopped script!"
      puts "Failed to run tests for #{current_browser.inspect}"
    end
  end

  task :delete_screenshots do
    Dir["tmp/*/"].map do |dir|
      if dir.include? 'screenshots_'
        FileUtils.rm_rf(dir[0...dir.length - 1])
      end
    end
  end

end
