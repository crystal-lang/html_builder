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
  def self.build : String
    String.build do |io|
      build(io) do |builder|
        with builder yield builder
      end
    end
  end

  def self.build(io : IO)
    new(io).build_impl do |builder|
      with builder yield builder
    end
  end

  @buffer : IO

  def initialize(@buffer : IO)
  end

  @[Deprecated("Use HTML.build directly")]
  def initialize(@buffer = String::Builder.new)
  end

  protected def build_impl
    with self yield self
  end

  @[Deprecated("Use HTML.build directly")]
  def build(&block)
    with self yield self
    @buffer.to_s
  end

  # Renders `HTML` doctype tag.
  #
  # ```
  # HTML::Builder.new.build { doctype } # => <doctype/>
  # ```
  def doctype
    @buffer << "<!DOCTYPE html>"
  end

  # Renders escaped text in html tag.
  #
  # ```
  # HTML::Builder.new.build { text "crystal is awesome" }
  # # => crystal is awesome
  # ```
  def text(text)
    HTML.escape(text, @buffer)
  end

  # Renders the provided html string.
  #
  # ```
  # HTML::Builder.new.build { html "<p>crystal is awesome</p>" }
  # # => <p>crystal is awesome</p>
  # ```
  def html(html)
    @buffer << html
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
    @buffer << "<"
    @buffer << name
    append_attributes_string(attrs)
    @buffer << ">"
    with self yield self
    @buffer << "</"
    @buffer << name
    @buffer << ">"
  end

  def tag(name, **attrs)
    @buffer << "<"
    @buffer << name
    append_attributes_string(**attrs)
    @buffer << ">"
    with self yield self
    @buffer << "</"
    @buffer << name
    @buffer << ">"
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
      @buffer << "<{{tag.id}}"
      append_attributes_string(attrs)
      @buffer << ">"
      with self yield self
      @buffer << "</{{tag.id}}>"
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
      @buffer << "<{{tag.id}}"
      append_attributes_string(**attrs)
      @buffer << ">"
      with self yield self
      @buffer << "</{{tag.id}}>"
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
      @buffer << "<{{tag.id}}"
      append_attributes_string(attrs)
      @buffer << ">"
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
      @buffer << "<{{tag.id}}"
      append_attributes_string(**attrs)
      @buffer << ">"
    end
  {% end %}

  private def append_attributes_string(attrs)
    attrs.try &.each do |name, value|
      @buffer << " "
      @buffer << name
      @buffer << %(=")
      HTML.escape(value, @buffer)
      @buffer << %(")
    end
  end

  private def append_attributes_string(**attrs)
    attrs.each do |name, value|
      @buffer << " "
      @buffer << name
      @buffer << %(=")
      HTML.escape(value, @buffer)
      @buffer << %(")
    end
  end
end

module HTML
  # Convenience method which invokes `HTML::Builder#build`.
  def self.build : String
    HTML::Builder.build do |builder|
      with builder yield builder
    end
  end

  # Convenience method which invokes `HTML::Builder#build`.
  def self.build(io : IO)
    HTML::Builder.build(io) do |builder|
      with builder yield builder
    end
  end
end
