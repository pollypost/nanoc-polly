#   This file is part of nanoc-polly, a nanoc backend for Pollypost.
#   Copyright (C) 2015 more onion
#
#   Pollypost is free software: you can use, redistribute and/or modify it
#   under the terms of the GNU General Public License version 3 or later.
#   See LICENCE.txt or <http://www.gnu.org/licenses/> for more details.


require 'rack'
require 'json'
module Rack
  class Polly
    DEFAULT_ASSETS_PATH_PREFIX = '/polly/assets/'
    DEFAULT_BACKEND_PATH_PREFIX = '/polly/'
    DEFAULT_IMAGE_STORAGE = ''

    def initialize(app, options = {})
      @app = app
      @options = {
        image_storage: DEFAULT_IMAGE_STORAGE,
        uploadcare_api_key: nil,
        backend_path_prefix: DEFAULT_ASSETS_PATH_PREFIX,
        assets_path_prefix: DEFAULT_BACKEND_PATH_PREFIX
      }.merge(options)
    end

    def call(env)
      dup._call(env)
    end

    protected

    def _call(env)
      @status, @headers, @response = @app.call(env)
      return [@status, @headers, @response] unless @headers['Content-Type'] =~ /html/
      response = Rack::Response.new([], @status, @headers)
      @response.each do |fragment|
        template = ""
        require_config = {
          'models/page_content' => {
            'backendPathPrefix' => @options[:backend_path_prefix]
          }
        }
        if @options[:image_storage] == 'uploadcare'
          require_config['views/bar_edit_mode'] = {
            'imageStorage' => @options[:image_storage]
          }
          template += <<END
<script>
UPLOADCARE_PUBLIC_KEY = "#{@options[:uploadcare_api_key]}";
</script>
END
        end
        template += <<END
<script>
var require = {
  config: #{JSON.pretty_generate(require_config)}
}
</script>
<script data-main=\"#{@options[:assets_path_prefix]}main.js\" src=\"#{@options[:assets_path_prefix]}require.js\"></script>
END
        response.write fragment.gsub(%r{</body>}, template + "</body>")
      end
      response.finish
    end
  end
end
