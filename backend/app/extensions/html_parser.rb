require 'nokogiri'

class HtmlParser
  def self.icon
    "fa-html5"
  end

  def initialize
  end

  # Put in HTML, get back a document
  def document_from_html(html)
    Nokogiri::HTML(html)
  end

  # obj can be a document, element, or array of elements
  def elements_from_css(obj, css)
    obj.css(css)
  end

  # returns text for a document, element, or array of elements
  def text_from_css(obj, css)
    obj.css(css).text
  end

  private
end
