require 'rubygems'
require 'minitest/autorun'
require 'selenium-webdriver'
require 'fileutils'
require 'active_support/inflector'
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
    @caps['browserstack.local'] = ENV['BS_LOCAL']
    @driver = Selenium::WebDriver.for(:remote,
                                      :url => url,
                                      :desired_capabilities => @caps)
  end

  def teardown
    @driver.quit if @driver
  end

  def save_screenshot(filename = 'screenshot')
    filename = 'screenshot' if filename == ''
    @driver.save_screenshot screenshot_filename(filename)
  end

  private

  def screenshot_filename(filename)
    path = ''
    counter = 0
    while path == '' || File.exists?(path) do
      path = File.join screenshot_path, "#{sanitize_filename(filename)}#{counter == 0 ? '' : counter}.png"
      counter += 1
    end

    path
  end

  def screenshot_path
    path = CrossBrowserHelper.capabilities.map{ |cap| @caps[cap]}.compact.join('_').squeeze('_')
    path = File.join ENV['SCREENSHOT_PATH'], path

    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end

    path
  end

  def sanitize_filename(filename)
    filename.parameterize '_'
  end
end
