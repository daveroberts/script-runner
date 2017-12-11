require 'rest-client'

class Http
  def self.icon
    "fa-globe"
  end

  def initialize
  end

  # HTTP Get: Response object has code, cookies, headers and body
  def http_get(url, headers={})
    response_to_hash(RestClient.get(url, headers))
  end

  # HTTP Post: Response object has code, cookies, headers and body
  def http_post(url, payload, headers={})
    response_to_hash(RestClient.post(url, payload, headers))
  end

  # HTTP Put: Response object has code, cookies, headers and body
  def http_puts(url, payload, headers={})
    response_to_hash(RestClient.put(url, payload, headers))
  end
  # HTTP Patch: Response object has code, cookies, headers and body
  def http_patch(url, payload, headers={})
    response_to_hash(RestClient.patch(url, payload, headers))
  end

  # HTTP Delete: Response object has code, cookies, headers and body
  def http_delete(url, headers={})
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
