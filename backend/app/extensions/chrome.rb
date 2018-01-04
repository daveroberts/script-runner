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
                description: "A hash, {id: 'sidebar'}, {name: 'search_bar'}, {link_text: 'Images'}" },
            ],
            returns: {
              name: "element",
              description: "The element"
            }
          },
          click: {
            summary: "Click something on the page.",
            params: [
              { name:        "element",
                description: "Element returned from `element` method" },
            ],
            returns: nil
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

    def initialize(trace=[])
      @trace = trace
    end

    def go_to_url(url)
      begin
        @trace.push({ summary: "Navigating to #{url}", level: :info, timestamp: Time.now })
        driver.get(url)
        return true
      rescue # usually a bad URL
        @trace.push({ summary: "Could not navigate to #{url}", level: :warn, timestamp: Time.now })
        return false
      end
    end

    def element(selector)
      begin
        return driver.find_element(selector)
      rescue Selenium::WebDriver::Error::NoSuchElementError => e
        @trace.push({ summary: "No such element found for #{selector}", level: :warn, timestamp: Time.now })
        return nil
      end
    end

    def click(element)
      if element
        @trace.push({ summary: "Clicking element", details: "Element #{element_to_s(element)}", show_details: false, level: :info, timestamp: Time.now })
        element.click()
        sleep 2
        wait_for_load()
        sleep 2
      else
        @trace.push({ summary: "Tried to click an element which doesn't exist", level: :error, timestamp: Time.now })
      end
    end

    def wait_for_load()
      wait = Selenium::WebDriver::Wait.new(:timeout => 60) # seconds
      count = 0
      begin
        wait.until do
          state = driver.execute_script('var browserState = document.readyState; return browserState;')
          puts state
          state == "complete"
        end
      rescue Timeout::Error
      end
    end

    def fill_in_textbox(element, data)
      @trace.push({ summary: "Typing `#{data}` into form", details: "Typed data `#{data}` into #{element_to_s(element)}", show_details: false, level: :info, timestamp: Time.now })
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
      image_id = ImageItem.save(data, "picture")
      @trace.push({ summary: "Taking screenshot", level: :info, image_id: image_id, show_image: true, timestamp: Time.now })
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
      @trace.push({ summary: "Found (#{links.length}) links on the page", level: :info, tables: [{
        title: "Links Found",
        headers: [
          { name: "URL", type: "string" }
        ],
        rows: links.map{|l| [{ value: l }] }
      }],
      show_tables: false,
      timestamp: Time.now })
      return links
    end

    def wait(seconds=5)
      sleep seconds
    end

    private

    def driver
      return @wd if @wd
      @trace.push({ summary: "Starting Chrome", level: :info, timestamp: Time.now })
      options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
      @wd = Selenium::WebDriver.for(:chrome, options: options)
      @wd.manage.window.resize_to(1920, 1080)
      return @wd
    end

    def element_to_s(element)
      return "(null)" if !element
      id = ""
      id = "##{element.attribute("id")}" if element.attribute("id")
      classname = ""
      classname = element.attribute("class").split.map{|c|".#{c}"}.join("") if element.attribute("class") if element.attribute("class")
      name = ""
      name = "[name=#{element.attribute("name")}]" if element.attribute("name")
      "#{element.tag_name}#{id}#{classname}#{name}".strip
    end
  end
end
