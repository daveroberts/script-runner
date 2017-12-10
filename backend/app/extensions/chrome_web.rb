require 'selenium-webdriver'
require 'securerandom'

class ChromeWeb
  def self.icon
    "fa-chrome"
  end

  def initialize
  end

  # Navigates to the given URL in chrome; returns nothing
  def go_to_url(url)
    driver.get(url)
  end

  # Get element from a selector.  Selector should be a hash like {:id "sidebar"} or {:name search_bar}
  def element(selector)
    driver.find_element(selector)
  end

  # Finds selector on page and fills in data.  Selector should be an object
  def fill_in_textbox(element, data)
    element.send_keys(data)
  end

  # Submit current web form
  def submit_form(element)
    element.submit
  end

  # Get inner text from element
  def text_from_element(element)
    element.text
  end

  # Returns raw data for png screenshot
  def screenshot()
    filename = SecureRandom.uuid
    filepath = "/tmp/#{filename}.png"
    driver.save_screenshot(filepath)
    data = File.read(filepath)
    File.delete(filepath)
    return data
  end

  private

  def driver
    return @wd if @wd
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    @wd = Selenium::WebDriver.for(:chrome, options: options)
    @wd.manage.window.resize_to(1920, 1080)
    return @wd
  end
end
