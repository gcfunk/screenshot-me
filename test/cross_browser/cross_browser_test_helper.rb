require 'rubygems'
require 'minitest/autorun'
require 'selenium-webdriver'
require 'fileutils'

class CrossBrowserTest < MiniTest::Unit::TestCase

  BROWSERSTACK_USERNAME = ENV["BROWSERSTACK_USERNAME"]
  BROWSERSTACK_ACCESS_KEY = ENV["BROWSERSTACK_ACCESS_KEY"]

  def self.localIdentifier
    #tag test runs with directory name
    return Dir.getwd().split('/').compact.last
  end

  def setup
    if BROWSERSTACK_USERNAME == ''
      puts "Please add BROWSERSTACK_USERNAME & BROWSERSTACK_ACCESS_KEY as parameters while running rake task"
      exit
    end
    url = "http://#{BROWSERSTACK_USERNAME}:#{BROWSERSTACK_ACCESS_KEY}@hub.browserstack.com/wd/hub"
    @caps = Selenium::WebDriver::Remote::Capabilities.new
    @caps['os'] = ENV['BS_AUTOMATE_OS'] unless ENV['BS_AUTOMATE_OS'].nil?
    @caps['os_version'] = ENV['BS_AUTOMATE_OS_VERSION'] unless ENV['BS_AUTOMATE_OS_VERSION'].nil?
    @caps['browser'] = ENV['SELENIUM_BROWSER'] unless ENV['SELENIUM_BROWSER'].nil?
    @caps['browser_version'] = ENV['SELENIUM_VERSION'] unless ENV['SELENIUM_VERSION'].nil?
    @caps['browserName'] = ENV['SELENIUM_BROWSER_NAME'] unless ENV['SELENIUM_BROWSER_NAME'].nil?
    @caps['platform'] = ENV['SELENIUM_PLATFORM'] unless ENV['SELENIUM_PLATFORM'].nil?
    @caps['device'] = ENV['BS_AUTOMATE_DEVICE'] unless ENV['BS_AUTOMATE_DEVICE'].nil?
    @caps['resolution'] = ENV['BS_AUTOMATE_RESOLUTION'] unless ENV['BS_AUTOMATE_RESOLUTION'].nil?

    @caps['browserstack.local'] = 'true'
    @caps['browserstack.localIdentifier'] = CrossBrowserTest.localIdentifier
    @driver = Selenium::WebDriver.for(:remote,
                                      :url => url,
                                      :desired_capabilities => @caps)
  end

  def teardown
    @driver.quit
  end

  def save_screenshot
    @driver.save_screenshot screenshot_filename
  end

  private

  def screenshot_filename
    @filename ||= 0
    @filename += 1

    "#{screenshot_path}/#{@filename}.png"
  end

  def screenshot_path
    path = ENV['SCREENSHOT_PATH'] +
      "#{@caps['os']}_#{@caps['os_version']}_#{@caps['browser']}_#{@caps['browser_version']}_" +
      "#{@caps['browserName']}_#{@caps['platform']}_#{@caps['device']}_#{@caps['resolution']}"

    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end

    path
  end
end
