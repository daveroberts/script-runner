require 'selenium-webdriver'
require 'securerandom'

class ChromeWeb
  def self.icon
    "fa-chrome"
  end

  def initialize
  end

  # Navigates to the given URL in chrome; returns true if navigation is successful
  def go_to_url(url)
    begin
      driver.get(url)
      return true
    rescue # usually a bad URL
      return false
    end
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
  def get_screenshot()
    filename = SecureRandom.uuid
    filepath = "/tmp/#{filename}.png"
    driver.save_screenshot(filepath)
    data = File.read(filepath)
    File.delete(filepath)
    return data
  end

  # Returns the full HTML after page has been rendered and changed by JavaScript
  def get_html()
    driver.execute_script("return document.documentElement.outerHTML")
  end

  # Returns the page source for the current page.  Does not render JavaScript.  See html() method instead
  def get_page_source()
    driver.page_source
  end

  # grabs all links on a webpage
  def get_links()
    anchors = driver.find_elements({ tag_name: 'a'})
    links = anchors.map{|a|a.attribute(:href)}
    return links
  end

  # pause for n seconds (defaults to 5)
  def wait(n=5)
    sleep n
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
