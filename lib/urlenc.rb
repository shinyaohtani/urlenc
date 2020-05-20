# frozen_string_literal: true

# Usage: urlenc [options]
#     -d, --decode  : Decode/unescape STDIN
#     -e, --encode  : Encode/escape   STDIN
module Urlenc
  require 'erb'
  require 'optparse'

  # Usage: urlenc [options]
  #     -d, --decode  : Decode/unescape STDIN
  #     -e, --encode  : Encode/escape   STDIN
  class Urlenc
    attr_accessor :params

    def initialize
      @params = {}
    end

    def parse_options
      OptionParser.new do |opts|
        opts = define_options(opts)
        opts.parse!(ARGV, into: @params)
        if @params[:decode].nil? and @params[:encode].nil?
          puts opts.help
        end
      end
    end

    def run
      if @params[:decode]
        STDIN.each { |line| puts CGI.unescape(line.chomp) }
      elsif @params[:encode]
        if @params[:split]
          STDIN.each do |line|
            protocol = line.chomp!.slice!(%r{^.+://}) || ''
            puts protocol + line.split('/', -1).map { |e| ERB::Util.url_encode(e) }.join('/')
          end
        else
          STDIN.each { |line| puts ERB::Util.url_encode(line.chomp) }
        end
      end
    end

    def define_options(opts)
      opts.version = VERSION
      opts.separator ' Required:'
      opts.on('-d', '--decode', 'Decode/unescape STDIN. %22Sample%20Text%21%22 to "Sample Text!"') { |v| v }
      opts.on('-e', '--encode', 'Encode/escape   STDIN. "Sample Text!" to %22Sample%20Text%21%22') { |v| v }
      opts.separator ''
      opts.separator ' Optional:'
      opts.on('-s', '--split',  'Split before Encode/escape. http://sample Text!/ to http://sample%20Text%21/') { |v| v }
      opts.separator ''
      opts.separator ' Common options:'
      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
      opts.on_tail('-V', '--version', 'Show version') do
        puts opts.ver
        exit
      end
      opts.banner = <<~BANNER

        #{opts.ver}
        #{DESCRIPTION}
        Usage: #{opts.program_name} {decode/encode} [options]
      BANNER
      opts
    end
  end
end
