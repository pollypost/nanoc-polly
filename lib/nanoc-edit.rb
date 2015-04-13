#   This file is part of nanoc-polly, a nanoc backend for Pollypost.
#   Copyright (C) 2015 more onion
#
#   Pollypost is free software: you can use, redistribute and/or modify it
#   under the terms of the GNU General Public License version 3 or later.
#   See LICENCE.txt or <http://www.gnu.org/licenses/> for more details.


usage       'edit [options]'
aliases     :e, :polly, :cracker
summary     'edit'
description 'Serve the nanoc site (like "nanoc view") and start a backend listener to process change requests. Optionally serve the pollypost assets.'

flag   :h, :help,  'show help for this command' do |value, cmd|
  puts cmd.help
  exit 0
end
flag   :a, :assets,  'serve the frontend assets at the assets_path_prefix (default: "/polly/assets")'
option :H, :handler, 'rack handler to use (default: thin, fallback: webrick)', :argument => :optional
option :p, :port, 'port to use (default: 3000)', :argument => :optional
option :i, :host, 'host to use (default: 0.0.0.0)', :argument => :optional

module Nanoc::CLI::Commands
  class Edit < ::Nanoc::CLI::CommandRunner
    DEFAULT_HANDLER_NAME = :thin
    DEFAULT_BACKEND_PATH_PREFIX = '/polly/'
    DEFAULT_ASSETS_PATH_PREFIX = '/polly/assets/'

    def run
      require_site

      require 'rack'
      require 'rack/polly'
      require 'adsf'

      # Get handler
      if options.key?(:handler)
        handler = Rack::Handler.get(options[:handler])
      else
        begin
          handler = Rack::Handler.get(DEFAULT_HANDLER_NAME)
        rescue LoadError
          handler = Rack::Handler::WEBrick
        end
      end

      with_assets = options[:assets] ? true : false
      if with_assets
        raise ArgumentError, "assets_location not configured" unless site.config[:polly][:assets_location]
      end

      # Set options
      options_for_rack = {
        Port: (options[:port] || 3000).to_i,
        Host: (options[:host] || '0.0.0.0')
      }

      # Build app
      site = self.site
      require 'nanoc/polly/backend'

      rack_polly_options = {}

      # set required options
      backend_path_prefix = site.config[:polly][:backend_path_prefix] ? site.config[:polly][:backend_path_prefix] : DEFAULT_BACKEND_PATH_PREFIX
      assets_path_prefix = site.config[:polly][:assets_path_prefix] ? site.config[:polly][:assets_path_prefix] : DEFAULT_ASSETS_PATH_PREFIX
      rack_polly_options = rack_polly_options.merge({
        assets_path_prefix: assets_path_prefix,
        backend_path_prefix: backend_path_prefix
      })

      # set image storage options
      image_storage = site.config[:polly][:image_storage] ? site.config[:polly][:image_storage] : false
      if image_storage && image_storage.to_s == 'uploadcare'
        raise ArgumentError, "uploadcare_api_key not configured" unless site.config[:polly][:uploadcare_api_key]
        rack_polly_options = rack_polly_options.merge({
          image_storage: image_storage,
          uploadcare_api_key: site.config[:polly][:uploadcare_api_key]
        })
      end

      app = Rack::Builder.new do
        map assets_path_prefix do
          run Rack::File.new(site.config[:polly][:assets_location])
        end if with_assets
        map '/' do
          use Rack::CommonLogger
          use Rack::ShowExceptions
          use Rack::Lint
          use Rack::Head
          use Adsf::Rack::IndexFileFinder, root: site.config[:output_dir]
          use Rack::Polly, rack_polly_options
          run Rack::File.new(site.config[:output_dir])
        end
        map backend_path_prefix do
         run Nanoc::Polly::Backend.new
        end
      end.to_app

      # Run autocompiler
      handler.run(app, options_for_rack)
    end
  end
end

runner Nanoc::CLI::Commands::Edit