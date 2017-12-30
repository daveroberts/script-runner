require 'rest-client'

module SimpleLanguage
  class Http
    def self._info
      {
        icon: "fa-globe",
        summary: "Call web services with HTTP(S)",
        methods: {
          get: {
            summary: "HTTP get",
            params: [
              { name:        "url",
                description: "URL of web service" },
              { name:        "headers",
                description: "hash of HTTP headers" },
            ],
            returns: {
              name:        "response hash",
              description: "{ code: 200, cookies: ['name':'value'], headers: ['name', 'value'], body: 'text' }"
            }
          },
          post: {
            summary: "HTTP post",
            params: [
              { name:        "url",
                description: "URL of web service" },
              { name:        "payload",
                description: "body of request" },
              { name:        "headers",
                description: "hash of HTTP headers" },
            ],
            returns: {
              name:        "response_hash",
              description: "{ code: 200, cookies: ['name':'value'], headers: ['name', 'value'], body: 'text' }"
            }
          },
          put: {
            summary: "HTTP put",
            params: [
              { name:        "url",
                description: "URL of web service" },
              { name:        "payload",
                description: "body of request" },
              { name:        "headers",
                description: "hash of HTTP headers" },
            ],
            returns: {
              name:        "response_hash",
              description: "{ code: 200, cookies: ['name':'value'], headers: ['name', 'value'], body: 'text' }"
            }
          },
          patch: {
            summary: "HTTP patch",
            params: [
              { name:        "url",
                description: "URL of web service" },
              { name:        "payload",
                description: "body of request" },
              { name:        "headers",
                description: "hash of HTTP headers" },
            ],
            returns: {
              name:        "response_hash",
              description: "{ code: 200, cookies: ['name':'value'], headers: ['name', 'value'], body: 'text' }"
            }
          },
          delete: {
            summary: "HTTP delete",
            params: [
              { name:        "url",
                description: "URL of web service" },
              { name:        "headers",
                description: "hash of HTTP headers" },
            ],
            returns: {
              name:        "response hash",
              description: "{ code: 200, cookies: ['name':'value'], headers: ['name', 'value'], body: 'text' }"
            }
          },
        }
      }
    end

    def initialize(trace)
      @trace = trace
    end

    def get(url, headers={})
      response_to_hash(RestClient.get(url, headers))
    end

    def post(url, payload, headers={})
      response_to_hash(RestClient.post(url, payload, headers))
    end

    def put(url, payload, headers={})
      response_to_hash(RestClient.put(url, payload, headers))
    end

    def patch(url, payload, headers={})
      response_to_hash(RestClient.patch(url, payload, headers))
    end

    def delete(url, headers={})
      response_to_hash(RestClient.delete(url, headers))
    end

    private

    def response_to_hash(response)
      {
        code: response.code,
        cookies: response.cookies,
        headers: response.headers,
        body: response.body,
      }
    end

  end
end
