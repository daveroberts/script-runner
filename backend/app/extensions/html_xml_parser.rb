require 'nokogiri'

class HtmlXmlParser
  def self.icon
    "fa-html5"
  end

  def initialize
  end

  # Put in HTML, get back a document
  def document_from_html(html)
    Nokogiri::HTML(html)
  end

  # Put in XML, get back a document
  def document_from_xml(xml)
    Nokogiri::XML(xml)
  end

  def xpath(doc, xpath)
    doc.xpath(xpath)
  end

  def attribute_from_node(node, attr)
    node.attributes[attr].value
  end

  def text_from_node(node)
    node.text
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
