# JustJaded - A Static Site Generator

Sometimes you want to write a personal website. But it's a pain. You don't like most static site generators. Chances are you won't like this one either, but F&#* you've tried all the ones that follow the rules; now it's time to break some.

# What is It?

Jaded is a Static Site Generator written as a Grunt Task. Specifically it __will__ be a fully comprehensive Static Site generator; similar to Jekyll.

# Installing

Scroll down to bottom...

## What does it do?

It compiles Jade with Yaml data templates!

## How it this different then me using Jade and Yaml?

Well it will be adding more technologies and helpers as time goes on. It's a work in progress.

Now it is notable the the intent was to use Yaml for all your data and use Jade for basic templates.

The early concept is a little rusty on implementing that idea and could use some development, a plan I am still working on.

Notably Jaded does have Glob Includes for both Jade and Yaml. Note the Following; yes it does work. Please see [jade-glob-include](http://github.com/KellyLSB/jade-glob-include) for more details.

```jade
body(class="includes")
  include includes/{header,sections/*,footer}
```

The Yaml includes work relatively the same.

```yaml
---
  title: Home
  recent_posts: include blog_posts/*.{yaml,yml}
```

Now I also broke the Yaml Spec in a couple other places by adding what I'm calling "Formats".

You can specify a Format in your initial page Yaml Config.

```yaml
---
  format!: 'default'
  title: Page
```

You can then change the resulting data by using `only!:`, `except!:` and direct `<format>!:` keys.

```yaml
---
  format!: 'default'
  title: page
  body:
    header:
      except!: ['minimal', 'no-header']
      content: My Header
    content:
      default!: |
        Lots of Text Here!
      minimal!: |
        Less Text.
    footer:
      only!: default
      content: Footer Message
```

Anyway I know it's unorthodox but hey. Opinions and new ideas, they power the world.

## What is the default Style Framework?

Since Compass is yet to be integrated... none. Unlike Bootstrap and other popular static site generators Jaded will be packaging Zurb Foundation by default.

## What will it do in the future?

- Uglify.JS
- SCSS Compiler - Compass
- Zurb Foundation Default Framework
- Static Asset Management
  - CDN Deploys
  - Image Compression
- Blog Helpers
  - Pagination
  - Tagging
  - Index Pages
  - JS Search?module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

- Sitemap
- Github Pages Generation

The goal is that all this will be customizable and extendable.
Let's see where this one goes?

# Damn I hate these hacks, sign me up.

`npm install justjaded --save-dev`
`

Gruntfile.coffee
```coffee
module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    justjaded:
      options:
        # Changes where
        # files output to.
        buildDir: '_build'
        # Made code pretty
        # Applies to all!
        pretty: true
        # Show debug information
        # Applies to all!
        debug: true
        # Jade additional template data
        jadeData:
          var: val
        # Jade Initialization function
        jadeInit: ->
          # String.prototype
          # extensions and the
          # like go here
      development:
        files:
          # Uses: _src/yaml/index.yaml
         'index.html': '_src/jade/index.jade'
          # Uses: _src/yaml/page2.yaml
         'page2.html': '_src/jade/page2.jade'
          # Uses: _src/yaml/page2/alt.yaml
         'page2/alt.html': '_src/jade/page2.jade'
      release:
        options:
          pretty: false
          debug: false
          buildDir: '.'
        files:
           # Uses: yaml/index.yaml
          'index.html': 'jade/index.jade'
           # Uses: yaml/page2.yaml
          'page2.html': 'jade/page2.jade'
           # Uses: yaml/page2/alt.yaml
          'page2/alt.html': 'jade/page2.jade'


  grunt.loadNpmTasks 'justjaded'
  grunt.registerTask 'build', ['justjaded:development']
  grunt.registerTask 'deploy', ['justjaded:release']
```
