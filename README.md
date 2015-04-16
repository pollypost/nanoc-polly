# Nanoc::Polly

## Integrate Pollypost with nanoc!

This Ruby Gem provides a backend for [Pollypost](https://github.com/pollypost/pollypost), so you can use browser based inline editing on static sites generated with [nanoc](http://nanoc.ws/).

## Installation

Install nanoc-polly yourself as:

    $ gem install nanoc-polly --pre

Or, if you're using [Bundler](http://bundler.io/), add this line to your application's Gemfile:

```ruby
gem 'nanoc-polly', "0.0.1.pre1"
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
