require 'rubygems'
require 'minitest/autorun'
require 'selenium-webdriver'
require 'fileutils'
require_relative '../../app/helpers/cross_browser_helper'

class CrossBrowserTest < MiniTest::Unit::TestCase

  BROWSERSTACK_USERNAME = ENV["BROWSERSTACK_USERNAME"]
  BROWSERSTACK_ACCESS_KEY = ENV["BROWSERSTACK_ACCESS_KEY"]

  def setup
    if BROWSERSTACK_USERNAME == ''
      puts "Please add BROWSERSTACK_USERNAME & BROWSERSTACK_ACCESS_KEY as parameters while running rake task"
      exit
    end
    url = "http://#{BROWSERSTACK_USERNAME}:#{BROWSERSTACK_ACCESS_KEY}@hub.browserstack.com/wd/hub"
    @caps = Selenium::WebDriver::Remote::Capabilities.new
    CrossBrowserHelper.environment_variables.each_pair do |key, value|
      @caps[key] = ENV[value] unless ENV[value].nil?
    end
    @caps['browserstack.local'] = 'true'
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

    path = File.join ENV['SCREENSHOT_PATH'], CrossBrowserHelper.capabilities.map{ |cap| @caps[cap]}.join('_')

    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end

    path
  end
end
