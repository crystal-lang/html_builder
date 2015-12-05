# html_builder

DSL for creating HTML programatically (extracted from Crystal's standard library).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  html_builder:
    github: crystal-lang/html_builder
```


## Usage


```crystal
require "html_builder"

html = HTML::Builder.new.a({href: "google.com"}) do
  text "crystal is awesome"
end

puts html # => "<a href="google.com">crystal is awesome</a>
```

Or also you can use `build` method:

```
HTML::Builder.new.build do
  a({href: "google.com"}) do
    text "crystal is awesome"
  end
end # => "<a href="google.com">crystal is awesome</a>


## Contributing

1. Fork it ( https://github.com/crystal-lang/html_builder/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
