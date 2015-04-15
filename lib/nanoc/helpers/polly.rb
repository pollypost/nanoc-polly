#   Copyright (C) 2015 more onion
#
#   Pollypost is free software: you can use, redistribute and/or modify it
#   under the terms of the GNU General Public License version 3 or later.
#   See LICENCE.txt or <http://www.gnu.org/licenses/> for more details.


module Nanoc::Helpers
  module Polly
    def item_about item
      if item[:about]
        item[:about]
      elsif item.path == '/' # special path
        'index'
      else
        # remove leading and trailing /
        item.path.sub(/\A\//,'').sub(/\/\z/, '')
      end
    end
  end
end
