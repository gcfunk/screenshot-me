require 'rubygems'
require 'rake/testtask'
require 'parallel'
require 'json'
require_relative '../../test/cross_browser/cross_browser_test_helper.rb'

namespace :test do

  @browsers = JSON.load(open('test/cross_browser/browsers.json'))
  @test_folder = "test/cross_browser/*_test.rb"
  @parallel_limit = ENV["nodes"] || 1
  @parallel_limit = @parallel_limit.to_i

  task :browserstacklocal do
    sh "BrowserStackLocal -localIdentifier #{CrossBrowserTest.localIdentifier} #{ENV['BROWSERSTACK_ACCESS_KEY']} localhost,3000,0"
  end

  def expand_browsers(browser_set, attr)
    return [browser_set] if browser_set[attr].nil? or !browser_set[attr].is_a?(Array)
    expanded_browsers = []

    browser_set[attr].each do |attr_item|
      temp_browser = browser_set.clone
      temp_browser[attr] = attr_item
      expanded_browsers += [temp_browser]
    end

    expanded_browsers
  end

  task :cross_browser do
    ['browser', 'browser_version', 'os', 'os_version', 'browserName', 'platform', 'device', 'resolution'].each do |attr|
      expanded_browsers = []
      @browsers.each do |browser_set|
        expanded_browsers += expand_browsers(browser_set, attr)
      end
      @browsers = expanded_browsers
    end

    current_browser = ""
    begin
      ENV['SCREENSHOT_PATH'] = "tmp/screenshots_#{Time.new.strftime('%Y_%m_%dT%H_%M_%S')}/"
      Parallel.map(@browsers, :in_threads => @parallel_limit) do |browser|
        current_browser = browser
        puts "Running with: #{browser.inspect}"
        ENV['SELENIUM_BROWSER'] = browser['browser']
        ENV['SELENIUM_VERSION'] = browser['browser_version']
        ENV['BS_AUTOMATE_OS'] = browser['os']
        ENV['BS_AUTOMATE_OS_VERSION'] = browser['os_version']
        ENV['SELENIUM_BROWSER_NAME'] = browser['browserName']
        ENV['SELENIUM_PLATFORM'] = browser['platform']
        ENV['BS_AUTOMATE_DEVICE'] = browser['device']
        ENV['BS_AUTOMATE_RESOLUTION'] = browser['resolution']
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
