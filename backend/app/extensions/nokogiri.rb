require 'nokogiri'

module SimpleLanguage
  class Nokogiri
    def self._info
      {
        icon: "fa-html5",
        summary: "Parse HTML or XML",
        methods: {
          document_from_html: {
            summary: "Put in HTML, get back a document",
            params: [
             { name:         "html",
               description:  "raw HTML or page source" },
            ],
            returns: {
              name:        "doc",
              description: "Nokogiri document"
            }
          },
          document_from_xml: {
            summary: "Put in XML, get back a document",
            params: [
             { name:         "xml",
               description:  "raw XML string" },
            ],
            returns: {
              name:        "doc",
              description: "Nokogiri document"
            }
          },
          elements_from_css: {
            summary: "Find elements based on a css selector",
            params: [
             { name:         "obj",
               description:  "Nokogiri document, element_list or element" },
             { name:         "css",
               description:  "CSS selector string" },
            ],
            returns: {
              name:        "element_list",
              description: "Nokogiri element list"
            }
          },
          text_from_css: {
            summary: "",
            params: [
             { name:         "obj",
               description:  "Nokogiri document, element_list or element" },
             { name:         "css",
               description:  "" },
            ],
            returns: {
              name:        "text",
              description: "Text from the passed object"
            }
          },
          text_from_node: {
            summary: "Extract text from a node",
            params: [
             { name:         "node",
               description:  "Nokogiri node" },
            ],
            returns: {
              name:        "text",
              description: "Inner text for node"
            }
          },
          attribute_from_node: {
            summary: "Get an attribute's value from a node",
            params: [
             { name:         "node",
               description:  "Nokogiri node" },
             { name:         "attr",
               description:  "Attribute name" },
            ],
            returns: {
              name:        "text",
              description: "The value of the attribute"
            }
          },
          xpath: {
            summary: "XPath selector",
            params: [
             { name:         "doc",
               description:  "Nokogiri document" },
             { name:         "xpath",
               description:  "xpath selector as string" },
            ],
            returns: {
              name:        "element_list",
              description: "Nokogiri element list"
            }
          },
        },
      }
    end

    def initialize
    end

    def document_from_html(html)
      Nokogiri::HTML(html)
    end

    def document_from_xml(xml)
      Nokogiri::XML(xml)
    end

    def elements_from_css(obj, css)
      obj.css(css)
    end

    def text_from_css(obj, css)
      obj.css(css).text
    end

    def text_from_node(node)
      node.text
    end

    def attribute_from_node(node, attr)
      node.attributes[attr].value
    end

    def xpath(doc, xpath)
      doc.xpath(xpath)
    end

    private
  end
end
