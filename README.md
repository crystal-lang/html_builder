# html_builder [![Build Status](https://travis-ci.org/crystal-lang/html_builder.svg)](https://travis-ci.org/crystal-lang/html_builder)

DSL for creating HTML programatically (extracted from Crystal's standard library).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  html_builder:
    github: crystal-lang/html_builder
```


## Usage

#### Basic usage
```crystal
require "html_builder"

html = HTML.build do
  a(href: "http://crystal-lang.org") do
    text "crystal is awesome"
  end
end

puts html
```

**Output** (this output is formatted for better display):
```html
<a href="http://crystal-lang.org">
  crystal is awesome
</a>
```


#### Full HTML5 page
```crystal
html = HTML.build do
  doctype
  html(lang: "pt-BR") do
    head do
      title { text "Crystal Programming Language" }

      meta(charset: "UTF-8")
    end
    body do
      a(href: "http://crystal-lang.org") { text "Crystal rocks!" }
      form(method: "POST") do
        input(name: "name")
      end
    end
  end
end

puts html
```

**Output** :
```html
<!DOCTYPE html>

<html lang="pt-BR">
  <head>
    <title>Crystal Programming Language</title>

    <meta charset="UTF-8">
  </head>

  <body>
    <a href="http://crystal-lang.org">Crystal rocks!</a>
    <form method="POST">
      <input name="name">
    </form>
  </body>
</html>
```

#### Custom tags

```crystal
html = HTML.build do
  tag("v-button", to: "home") { text "Home" }
end

puts html
```

**Output**:
```html
<v-button to="home">
  Home
</v-button>
```

#### Safety

HTML::Builder escapes attribute values:
```crystal
html = HTML.build do
  a(href: "<>") { }
end

puts html
```

**Output**:
```html
<a href="&lt;&gt;"></a>
```

And escapes text:
```crystal
html = HTML.build do
  a { text "<>" }
end

puts html
```

**Output**:
```html
<a>&lt;&gt;</a>
```
## Contributing

1. Fork it ( https://github.com/crystal-lang/html_builder/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
