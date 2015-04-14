#   This file is part of nanoc-polly, a nanoc backend for Pollypost.
#   Copyright (C) 2015 more onion
#
#   Pollypost is free software: you can use, redistribute and/or modify it
#   under the terms of the GNU General Public License version 3 or later.
#   See LICENCE.txt or <http://www.gnu.org/licenses/> for more details.


module Nanoc::Polly
  class Config
    class << self
      attr_accessor :data_source_index
    end

    def self.data_source_index
      @data_source_index || 0
    end
  end
end
