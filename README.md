# Nanoc::Polly

## Integrate Pollypost with nanoc!

This Ruby Gem provides a backend for [Pollypost](https://github.com/pollypost/pollypost), so you can use browser based inline editing on static sites generated with [nanoc](http://nanoc.ws/).

## Installation

Install nanoc-polly yourself as:

    $ gem install nanoc-polly

Or, if you're using [Bundler](http://bundler.io/), add this line to your application's Gemfile:

```ruby
gem 'nanoc-polly'
```

And then execute:

    $ bundle install

### Development version

In case you want to use the most up-to-date development version, add this GitHub path to your Gemfile:

```ruby
gem 'nanoc-polly', :github => 'pollypost/nanoc-polly'
```
or, if you cloned the source files to your local file system:

```ruby
gem 'nanoc-polly', :path => './path_to/nanoc-polly'
```

### Polly Helper

Nanoc-polly comes with a predefined helper that adds functionality for generating the 'about' tags needed for Pollypost. See [Pollypost](https://github.com/pollypost/pollypost) for details.

To activate the helper, add this line to a file in your `lib` folder:

```ruby
include Nanoc::Helpers::Polly
```

You can then generate a file's 'about' value with `item_about @item`:

```html
<div class="edit-this" about="<%= item_about @item %>">
  <%= yield %>
</div>
```

## Usage

To enable Pollypost on your site, just start the nanoc webserver with

    $ nanoc edit -a

This behaves very similar to `nanoc view` but adds all the components needed for Pollypost. The `-a` Option loads all the assets shipped with Pollypost, without it you'd have to make sure yourself that the files are found on the specified path (see Config Options).

Your site is available at `localhost:3000`.

For additional options try `nanoc edit --help`.

## Config Options

In your nanoc.yaml file you can set the following configuration options for Pollypost (shown here are their default values):

```ruby
polly:
  assets_location: 'public/polly'       # folder where the compiled Pollypost assets are stored
  assets_path_prefix: '/polly/assets/'  # url prefix for Pollypost asset paths
  backend_path_prefix: '/polly/'        # url prefix for Pollypost backend paths
  image_storage: ''                     # which image storage to use (e.g. 'uploadcare')
  uploadcare_api_key: ''                # api key if you are using uploadcare as image storage
```

## Contributing

1. Fork it ( https://github.com/pollypost/nanoc-polly/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License

Copyright (C) 2015 [more onion](https://www.more-onion.com)

Pollypost is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Pollypost is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License (LICENSE.md) along with this program. If not, see <http://www.gnu.org/licenses/>.
