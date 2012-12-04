require 'uri'
class Dialect < WLang::Html

  def at(buf, href, label)
    href, label = render(href), render(label)
    buf << %Q{<a target="_blank" href="#{href}">#{label}</a>}
  end

  def escape_uri(buf, text)
    buf << URI.escape(evaluate(text), Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  
  tag '@', :at
  tag '&', :escape_uri
end
