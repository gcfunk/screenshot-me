class CrossBrowserHelper

  def self.expand_browsers(browsers)
    capabilities.each do |attr|
      expanded_browsers = []
      browsers.each do |browser_set|
        expanded_browsers += expand_browser_set(browser_set, attr)
      end
      browsers = expanded_browsers
    end

    browsers
  end

  def self.environment_variables
    {
      'browser'         => 'SELENIUM_BROWSER',
      'browser_version' => 'SELENIUM_VERSION',
      'os'              => 'BS_AUTOMATE_OS',
      'os_version'      => 'BS_AUTOMATE_OS_VERSION',
      'browserName'     => 'SELENIUM_BROWSER_NAME',
      'platform'        => 'SELENIUM_PLATFORM',
      'device'          => 'BS_AUTOMATE_DEVICE',
      'resolution'      => 'BS_AUTOMATE_RESOLUTION',
    }
  end

  def self.capabilities
    environment_variables.keys
  end

  private

  def self.expand_browser_set(browser_set, attr)
    return [browser_set] if browser_set[attr].nil? or !browser_set[attr].is_a?(Array)
    expanded_browsers = []

    browser_set[attr].each do |attr_item|
      temp_browser = browser_set.clone
      temp_browser[attr] = attr_item
      expanded_browsers += [temp_browser]
    end

    expanded_browsers
  end
end
