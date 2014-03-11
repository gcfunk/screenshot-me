require_relative 'cross_browser_test_helper'

class IlikaiTest < CrossBrowserTest

  def test_post
    root_path = 'http://localhost:3000/'
    pages = [
        '',
        'pages/about-the-ilikai',
        'pages/residences'
    ]

    pages.each do |page|
      @driver.navigate.to root_path + page
      save_screenshot
    end
  end

end
