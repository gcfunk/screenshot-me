require_relative 'cross_browser_test_helper'

class ExampleTest < CrossBrowserTest

  def test_pages
    root_path = 'https://github.com/'
    pages = [
        '',
        'explore',
        'features',
        'blog'
    ]

    pages.each do |page|
      @driver.navigate.to root_path + page
      save_screenshot
    end
  end

end
