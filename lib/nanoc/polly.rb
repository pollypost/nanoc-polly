#   This file is part of nanoc-polly, a nanoc backend for Pollypost.
#   Copyright (C) 2015 more onion
#
#   Pollypost is free software: you can use, redistribute and/or modify it
#   under the terms of the GNU General Public License version 3 or later.
#   See LICENCE.txt or <http://www.gnu.org/licenses/> for more details.


require "nanoc/polly/version"
require 'nanoc'
require 'nanoc/cli'
require 'nanoc/cli/command_runner'

module Nanoc
  module Polly
    filename = File.dirname(__FILE__) + '/../nanoc-edit.rb'
    Nanoc::CLI.after_setup do
      cmd = Nanoc::CLI.load_command_at(filename, 'edit')
      Nanoc::CLI.root_command.add_command(cmd)
    end
  end
end
