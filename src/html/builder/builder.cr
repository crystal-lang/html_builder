require "html"

# Defines a DSL for creating HTML.
#
# Usage:
#
# ```
# require "html_builder"
#
# html = HTML.build do
#   a(href: "http://crystal-lang.org") do
#     text "crystal is awesome"
#   end
# end
#
# puts html # => %(<a href="http://crystal-lang.org">crystal is awesome</a>)
# ```
struct HTML::Builder
  # Creates a new HTML::Builder, yields with with `with ... yield`
  # and then returns the resulting string.
  def self.build
    new.build do |builder|
      with builder yield builder
    end
  end

  def initialize
    @str = IO::Memory.new
  end

  def build
    with self yield self
    @str.to_s
  end

  # Renders `HTML` doctype tag.
  #
  # ```
  # HTML::Builder.new.build { doctype } # => <doctype/>
  # ```
  def doctype
    @str << "<!DOCTYPE html>"
  end

  # Renders escaped text in html tag.
  #
  # ```
  # HTML::Builder.new.build { text "crystal is awesome" }
  # # => crystal is awesome
  # ```
  def text(text)
    @str << HTML.escape(text)
  end

  # Renders the provided html string.
  #
  # ```
  # HTML::Builder.new.build { html "<p>crystal is awesome</p>" }
  # # => <>crystal is awesome</p>
  # ```
  def html(html)
    @str << html
  end

  # Renders the provided html tag with any options.
  #
  # ```
  # HTML::Builder.new.build do
  #   tag("section", {class: "crystal"}) { text "crystal is awesome" }
  # end
  # # => <section class="crystal">crystal is awesome</section>
  # ```
  def tag(name, attrs)
    @str << "<#{name}"
    append_attributes_string(attrs)
    @str << ">"
    with self yield self
    @str << "</#{name}>"
  end

  def tag(name, **attrs)
    @str << "<#{name}"
    append_attributes_string(**attrs)
    @str << ">"
    with self yield self
    @str << "</#{name}>"
  end

  {% for tag in %w(a abbr address article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup data datalist dd del details dfn dialog div dl dt em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup html i ins kbd label legend li main map mark menu meter nav noscript object ol optgroup option output p picture pre progress q rp rt ruby s samp script section select slot small span strong style sub summary sup svg table tbody td template textarea tfoot th thead time title tr u ul var video) %}
    # Renders `{{tag.id.upcase}}` html tag with any options.
    #
    # ```
    # HTML::Builder.new.build do
    #   {{tag.id}}({:class => "crystal" }) { text "crystal is awesome" }
    # end
    # # => <{{tag.id}} class="crystal">crystal is awesome</{{tag.id}}>
    # ```
    def {{tag.id}}(attrs)
      @str << "<{{tag.id}}"
      append_attributes_string(attrs)
      @str << ">"
      with self yield self
      @str << "</{{tag.id}}>"
    end

    # Renders `{{tag.id.upcase}}` html tag with any options.
    #
    # ```
    # HTML::Builder.new.build do
    #   {{tag.id}}(class: "crystal") { text "crystal is awesome" }
    # end
    # # => <{{tag.id}} class="crystal">crystal is awesome</{{tag.id}}>
    # ```
    def {{tag.id}}(**attrs)
      @str << "<{{tag.id}}"
      append_attributes_string(**attrs)
      @str << ">"
      with self yield self
      @str << "</{{tag.id}}>"
    end
  {% end %}

  {% for tag in %w(area base br col embed hr img input link meta source track wbr) %}
    # Renders `{{tag.id.upcase}}` html tag with any options.
    #
    # ```
    # HTML::Builder.new.build do
    #   {{tag.id}}({:class => "crystal")
    # end
    # # => <{{tag.id}} class="crystal">
    # ```
    def {{tag.id}}(attrs)
      @str << "<{{tag.id}}"
      append_attributes_string(attrs)
      @str << ">"
    end

    # Renders `{{tag.id.upcase}}` html tag with any options.
    #
    # ```
    # HTML::Builder.new.build do
    #   {{tag.id}}(class: "crystal")
    # end
    # # => <{{tag.id}} class="crystal">
    # ```
    def {{tag.id}}(**attrs)
      @str << "<{{tag.id}}"
      append_attributes_string(**attrs)
      @str << ">"
    end
  {% end %}

  private def append_attributes_string(attrs)
    attrs.try &.each do |name, value|
      @str << " "
      @str << name
      @str << %(=")
      HTML.escape(value, @str)
      @str << %(")
    end
  end

  private def append_attributes_string(**attrs)
    attrs.each do |name, value|
      @str << " "
      @str << name
      @str << %(=")
      HTML.escape(value, @str)
      @str << %(")
    end
  end
end

module HTML
  # Convenience method which invokes `HTML::Builder#build`.
  def self.build
    HTML::Builder.build do |builder|
      with builder yield builder
    end
  end
end
