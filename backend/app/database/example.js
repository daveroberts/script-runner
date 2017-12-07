site = "CNN"
url = "https://www.cnn.com"
go_to_url(url)
page = page_source()
img = screenshot()
store({url: url, page: page, image: img['full'], retrieved_at: now()}, join([site,"_pages"]))
html = parse(page)
links = css(html, 'a')
links = map(links, (link)->{ attr(link, "href") })
links = regex(links, "^https.*cnn\.com.*html$")
foreach link in links {
  if set_has_value(join([site,"_urls"]), link) {
  } else {
    go_to_url(link)
    page = page_source()
    img = screenshot()
    data = {url: link, page: page, image: img['full'], retrieved_at: now()}
    store(data, join([site,"_pages"]))
    set_store(join([site,"_urls"]), link)
    queue(join([site, "_raw"], data)
  }
}
