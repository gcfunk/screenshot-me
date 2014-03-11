class CrossBrowserHelper

  def self.expand_browsers(browsers)
    ['browser', 'browser_version', 'os', 'os_version', 'browserName', 'platform', 'device', 'resolution'].each do |attr|
      expanded_browsers = []
      browsers.each do |browser_set|
        expanded_browsers += CrossBrowserHelper.expand_browser_set(browser_set, attr)
      end
      browsers = expanded_browsers
    end

    browsers
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
