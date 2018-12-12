require "org2hiki/version"
require "org2hiki/org2hiki"
require 'thor'

module Org2hiki
  class CLI < Thor
    def initialize(*args)
      super
    end

    desc 'version, -v', 'show program version'
  #    map "--version" => "version"
    map "--version" => "version"
    def version
      puts Hiki2org::VERSION
    end


    desc 'convert', 'convert FILE.org to FILE.hiki'
    def convert(*args)
      puts "{{toc}}\n\n"
      print To_Hiki.new.convert(File.read(args[0]))
    end


  end
end
