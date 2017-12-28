require 'selenium-webdriver'
require 'securerandom'

module SimpleLanguage
  class Chrome
    def self._info
      {
        icon: "fa-chrome",
        summary: "Lauches the Chrome browser and allows for navigation and pull back of data",
        methods: {
          go_to_url: {
            summary: "Navigate to a URL",
            params: [
              { name:        "url",
                description: "Go to this URL" },
            ],
            returns: {
              name: "boolean",
              description: "true on successful navigation, otherwise false (usually a bad URL)"
            }
          },
          element: {
            summary: "Get element from a selector.",
            params: [
              { name:        "selector",
                description: "A hash, {id: 'sidebar'} or {name: 'search_bar'}" },
            ],
            returns: {
              name: "element",
              description: "The element"
            }
          },
          fill_in_textbox: {
            summary: "Enter data into a web form.",
            params: [
              { name:        "element",
                description: "Element returned from `element` method" },
              { name:        "data",
                description: "Data to type into the textbox" },
            ],
            returns: nil
          },
          submit_form: {
            summary: "Submits a web form.",
            params: [
              { name:        "element",
                description: "Any element in the web form" },
            ],
            returns: nil
          },
          text_from_element: {
            summary: "The text of an element",
            params: [
              { name:        "element",
                description: "Element returned from `element` method" },
            ],
            returns: {
              name: "text",
              description: "The inner text of an element"
            }
          },
          screenshot: {
            summary: "Take a screenshot of a webpage",
            params: [
            ],
            returns: {
              name: "data",
              description: "The raw screenshot data"
            }
          },
          html: {
            summary: "Returns the full HTML after page has been rendered and changed by JavaScript",
            params: [
            ],
            returns: {
              name: "text",
              description: "The HTML"
            }
          },
          page_source: {
            summary: "Returns the page source for the current page.  Does not render JavaScript.  See html() method instead",
            params: [
            ],
            returns: {
              name: "text",
              description: "The page source"
            }
          },
          links: {
            summary: "grabs all links on a webpage",
            params: [
            ],
            returns: {
              name: "array",
              description: "All the links from the webpage"
            }
          },
          wait: {
            summary: "wait for a few seconds before taking the next action",
            params: [
              { name:        "seconds",
                description: "number of seconds to pause (defaults to 5)" },
            ],
            returns: nil
          },
        }
      }
    end

    def initialize
    end

    def go_to_url(url)
      begin
        driver.get(url)
        return true
      rescue # usually a bad URL
        return false
      end
    end

    def element(selector)
      driver.find_element(selector)
    end

    def fill_in_textbox(element, data)
      element.send_keys(data)
    end

    def submit_form(element)
      element.submit
    end

    def text_from_element(element)
      element.text
    end

    def screenshot()
      filename = SecureRandom.uuid
      filepath = "/tmp/#{filename}.png"
      driver.save_screenshot(filepath)
      data = File.read(filepath)
      File.delete(filepath)
      return data
    end

    def html()
      driver.execute_script("return document.documentElement.outerHTML")
    end

    def page_source()
      driver.page_source
    end

    def links()
      anchors = driver.find_elements({ tag_name: 'a'})
      links = anchors.map{|a|a.attribute(:href)}
      return links
    end

    def wait(seconds=5)
      sleep seconds
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
end
