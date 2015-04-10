#   This file is part of nanoc-polly, a nanoc backend for Pollypost.
#   Copyright (C) 2015 more onion
#
#   Pollypost is free software: you can use, redistribute and/or modify it
#   under the terms of the GNU General Public License version 3 or later.
#   See LICENCE.txt or <http://www.gnu.org/licenses/> for more details.


require 'sinatra/base'
require 'json'
require 'nanoc'
require 'loofah'
require 'htmlbeautifier'

module Nanoc::Polly
class Backend < Sinatra::Base
  get '/' do
    'Go away. Nothing to see'
  end

  # CREATE
  post '/content' do
    content_type :json
    body = request.body.read
    json = JSON.parse(body)

    # identifier is alphanum or '/', but not only '/'s
    identifier = nil
    if json['about'] && json['about'].match(/\A[a-z0-9\/]+\z/) && !json['about'].match(/\A\/+\z/)
      about = json['about'].gsub(%r{\A/+|/+\z}, '')
      if about == 'index'
        identifier = '/'
      else
        identifier = '/' + about + '/'
      end
    else
      return [400, {}, {
        about: identifier,
        message: "Invalid request."
      }.to_json ]
    end

    if identifier && json['content']
      # TODO find a way to not have to load the site twice in one request
      # assuming we are running in a nanoc site dir
      site = Nanoc::Site.new('.')
      data_source = Nanoc::DataSources::FilesystemUnified.new(site, '/', '/', {})
      if site.items[identifier]
        return [409, {}, {
          about: identifier,
          message: "Page already exists."
        }.to_json ]
      end

      sanitized_content = sanitize_content(json['content'])
      data_source.create_item(sanitized_content, {
        about: about,
        title: json['title'] ? json['title'] : 'Title',
        layout: 'default'}, identifier)
      recompile!
      return [ 202, {}, {
        about: identifier,
        message: "Page creation request accepted.",
        content: sanitized_content
      }.to_json ]
    else
      return [400, {}, {
        message: "Invalid request."
      }.to_json ]
    end
  end

  # READ
  get %r{/(content|page)/([a-z0-9\/]+)} do
    content_type :json
    about = params[:captures][1].gsub(%r{\A/+|/+\z}, '')
    if about == 'index'
      identifier = '/'
    else
      # identifier is alphanum or '/', but not only '/'s
      if about.match(/\A\/+\z/)
        return [400, {}, {
          message: "Invalid request."
        }.to_json ]
      end
      identifier = '/' + about + '/'
    end

    # TODO find a way to not have to load the site twice in one request
    # assuming we are running in a nanoc site dir
    site = Nanoc::Site.new('.')
    if site.items[identifier]
      return [200, {}, {
        about: identifier,
        content: site.items[identifier].raw_content,
        attributes: sanitize_attributes(site.items[identifier].attributes)
      }.to_json ]
    else
      return [404, {}, {
        about: identifier,
        message: "Not found."
      }.to_json ]
    end
  end

  # UPDATE
  put %r{/(content|page)/([a-z0-9\/]+)} do
    content_type :json
    about = params[:captures][1].gsub(%r{\A/+|/+\z}, '')
    if about == 'index'
      identifier = '/'
    else
      # identifier is alphanum or '/', but not only '/'s
      if about.match(/\A\/+\z/)
        return [400, {}, {
          message: "Invalid request."
        }.to_json ]
      end
      identifier = '/' + about + '/'
    end

    # TODO find a way to not have to load the site twice in one request
    # assuming we are running in a nanoc site dir
    site = Nanoc::Site.new('.')
    data_source = Nanoc::DataSources::FilesystemUnified.new(site, '/', '/', {})
    attributes = []
    # read and use attributes from saved item
    if item = site.items[identifier]
      attributes = sanitize_attributes(item.attributes)
    else
      return [404, {}, {
        about: identifier,
        message: "Not found."
      }.to_json ]
    end

    body = request.body.read
    json = JSON.parse(body)
    if json['content']
      sanitized_content = sanitize_content(json['content'])
      attributes.merge!(json['attributes']) if json['attributes']
      # make sure that about is not overriden in PUT
      # we always want this to be the value given in the request path
      attributes[:about] = about
      data_source.create_item(sanitized_content, attributes, identifier)
      recompile!
      return [ 202, {}, {
        about: identifier,
        message: "Page update request accepted.",
        content: sanitized_content
      }.to_json ]
    else
      return [400, {}, {
        message: "Invalid request."
      }.to_json ]
    end
  end

  # DELETE
  delete %r{/content/([a-z0-9\/]+)} do
    content_type :json
    return [501, {}, {
      message: "DELETE not implemented yet. Thank you come again!"
    }.to_json]
  end

  error do
    content_type :json
    return [500, {}, {
      message: "Something bad has happened."
    }.to_json]
  end

  # @TODO
  def sanitize_about about
    return about
  end

  # @TODO
  # TODO maybe as a nonblocking background task
  def sanitize_content content = ''
    # see https://github.com/flavorjones/loofah
    sanitized_content = Loofah.fragment(content).scrub!(:prune).to_s
    beautified_output = HtmlBeautifier.beautify(sanitized_content)
    return beautified_output
  end

  def sanitize_attributes attributes
    blacklist = [:mtime, :file, :filename, :extension, :meta_filename, :content_filename]
    return attributes.delete_if { |k,v| blacklist.include? k }
  end

  # TODO maybe as a nonblocking background task
  def recompile!
    # difficult to cache site because of nanoc internal caching (freeze)
    # TODO optimize recompilation
    # assuming we are running in a nanoc site dir
    site = Nanoc::Site.new('.')
    site.compile
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
end
